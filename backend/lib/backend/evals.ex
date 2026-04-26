defmodule Backend.Evals do
  @moduledoc """
  Business logic for the model consistency and confidence evaluations
  """

  @csv_file_path Path.join([:code.priv_dir(:backend), "static", "csv", "evaluation_results.csv"])
  @current_run_csv_path Path.join([:code.priv_dir(:backend), "static", "csv", "current_run.csv"])
  @progression_csv_path Path.join([:code.priv_dir(:backend), "static", "csv", "consistency_progression.csv"])

  @doc """
    Used for confidence calculation
    Call the consistency eval for all the models in a list of models passed by the user

  """
  def confidence_eval(schema_ddl, question, models, num_queries, schema_info, checkpoints \\ []) do
    # Generate a unique run_id for this evaluation
    run_id = :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower)

    # Set up the database schema
    setup_result = case schema_info do
      {:preset, schema_name} ->
        Backend.DatabaseSetup.setup_schema(schema_name)

      {:custom, _ddl} ->
        Backend.DatabaseSetup.setup_custom_schema(schema_ddl)
    end

    case setup_result do
      {:ok, db_schema_name} ->
        try do
          # Generate queries for each model in parallel and calculate consistency
          queries_by_model =
            models
            |> Task.async_stream(
              fn model ->
                queries = get_queries(schema_ddl, question, model, num_queries)
                results = get_results(db_schema_name, queries)
                consistency = compare_results(results)

                %{
                  model: model,
                  queries: queries,
                  results: results,
                  consistency: consistency
                }
              end,
              max_concurrency: length(models),
              timeout: :infinity,
              on_timeout: :kill_task
            )
            |> Enum.map(fn
              {:ok, result} -> result
              {:exit, reason} ->
                require Logger
                Logger.error("Model processing failed: #{inspect(reason)}")
                nil
            end)
            |> Enum.reject(&is_nil/1)

          # Calculate confidence by aggregating consistency vectors from all models
          confidence = calculate_confidence(queries_by_model)

          result = %{
            models: queries_by_model,
            confidence: confidence
          }

          # Log results to CSV
          if checkpoints != [] do
            # Ensure the final num_queries is always included
            all_checkpoints = Enum.uniq(checkpoints ++ [num_queries]) |> Enum.sort()

            # Log at each checkpoint with recomputed metrics for that subset
            Enum.each(all_checkpoints, fn checkpoint ->
              if Enum.all?(queries_by_model, fn m -> length(m.results) >= checkpoint end) do
                checkpoint_models = Enum.map(queries_by_model, fn model_data ->
                  checkpoint_results = Enum.take(model_data.results, checkpoint)
                  checkpoint_consistency = compare_results(checkpoint_results)
                  %{model_data | consistency: checkpoint_consistency}
                end)

                checkpoint_confidence = calculate_confidence(checkpoint_models)
                checkpoint_result = %{models: checkpoint_models, confidence: checkpoint_confidence}
                log_to_csv(checkpoint_result, schema_info, question, models, checkpoint, run_id)
              end
            end)

            # Log consistency progression
            log_progression_csv(run_id, schema_info, question, queries_by_model, checkpoints)
          else
            # No checkpoints — log once with full num_queries
            log_to_csv(result, schema_info, question, models, num_queries, run_id)
          end

          # Log current run data (overwritten each run)
          log_current_run_csv(result)

          result
        after
          # Clean up the schema after we're done
          Backend.DatabaseSetup.cleanup_schema(db_schema_name)
        end

      {:error, reason} ->
        raise "Failed to setup database schema: #{reason}"
    end
  end

  # Make this function take in the schema, the question, the model and the amount of different
  # queries to generate, with that:
  # - Have it concurrently generate the queries by calling OpenRouter with the OPENROUTER_KEY
  #
  # return: an array of queries
  defp get_queries(schema, question, model, num_queries)
    when is_integer(num_queries) and num_queries > 0 do
  1..num_queries
  |> Task.async_stream(
    fn _i ->
      generate_query(schema, question, model)
    end,
    max_concurrency: 10,
    timeout: 180_000,
    on_timeout: :kill_task
  )
  |> Enum.map(fn
    {:ok, query} ->
      query
    {:exit, reason} ->
      require Logger
      Logger.error("Query generation failed for model #{model}: #{inspect(reason)}")
      nil
  end)
  |> Enum.reject(&is_nil/1)
end


  defp generate_query(schema, question, model) do
    require Logger
    api_key = System.get_env("OPENROUTER_API_KEY")

    unless api_key do
      raise "OPENROUTER_API_KEY environment variable is not set"
    end

    prompt = """
    You are an SQL generating chatbot. You will generate PostgreSQL queries that takes into consideration the following schema.
    \n\n
    #{schema}
    \n\n

    You will only return the markdown sql query.

    Generate a SQL query to answer this question:
    #{question}

    Do not rename columns at all. Avoid ommitting JOINed attributes in the final results, unless they are repeated.

    """

    body = %{
      model: model,
      messages: [
        %{
          role: "user",
          content: prompt
        }
      ]
    }

    Logger.debug("[OpenRouter] Sending request → #{model}")
    t0 = System.monotonic_time(:millisecond)

    result = case Req.post("https://openrouter.ai/api/v1/chat/completions",
      json: body,
      headers: [
        {"Authorization", "Bearer #{api_key}"},
        {"Content-Type", "application/json"}
      ],
      receive_timeout: 120_000,
      finch: Backend.Finch
    ) do
      {:ok, %{status: 200, body: response}} ->
        response
        |> get_in(["choices", Access.at(0), "message", "content"])
        |> String.trim()
        |> strip_markdown()

      {:ok, %{status: status, body: body}} ->
        raise "OpenRouter API returned status #{status}: #{inspect(body)}"

      {:error, reason} ->
        raise "Failed to call OpenRouter API: #{inspect(reason)}"
    end

    elapsed = System.monotonic_time(:millisecond) - t0
    Logger.debug("[OpenRouter] Response received ← #{model} (#{elapsed}ms)")
    result
  end

  defp strip_markdown(content) do
    content
    # Remove ```sql and ``` markers
    |> String.replace(~r/^```(?:sql)?\n?/m, "")
    |> String.replace(~r/\n?```$/m, "")
    |> String.trim()
  end

  # Make this function take in the schema and the results array and:
  # - Run each result in the appropriate PSQL database
  # - Order the results for comparison
  #
  # return: the array of ordered results
  defp get_results(_schema_name, queries) do
    Enum.map(queries, fn query ->
      case Ecto.Adapters.SQL.query(Backend.Repo, query) do
        {:ok, %{rows: rows, columns: columns}} ->
          # Normalize the result for consistent comparison
          normalize_result(columns, rows)

        {:error, %Postgrex.Error{} = error} ->
          %{
            error: true,
            message: Exception.message(error),
            query: query
          }
      end
    end)
  end

  defp normalize_result(columns, rows) do
    # Create column index mapping for sorting
    indexed_columns = Enum.with_index(columns)

    # Sort columns alphabetically and get the new order
    sorted_columns_with_indices =
      indexed_columns
      |> Enum.sort_by(fn {col, _idx} -> col end)

    sorted_columns = Enum.map(sorted_columns_with_indices, fn {col, _idx} -> col end)
    column_order = Enum.map(sorted_columns_with_indices, fn {_col, idx} -> idx end)

    # Reorder each row according to the new column order
    reordered_rows =
      Enum.map(rows, fn row ->
        Enum.map(column_order, fn idx -> Enum.at(row, idx) end)
      end)

    # Sort rows for consistent comparison
    sorted_rows = Enum.sort(reordered_rows)

    %{
      columns: sorted_columns,
      rows: sorted_rows,
      row_count: length(rows)
    }
  end

  # Calculate confidence scores by looking at how each result appears across all models' consistency vectors.
  # Returns all confidence scores sorted by confidence level.
  #
  # return: confidence metric with all confidence scores
  defp calculate_confidence(queries_by_model) do
    # Extract all unique results from all models' consistency vectors
    all_result_frequencies =
      queries_by_model
      |> Enum.flat_map(fn model_data ->
        model_data.consistency.consistency_vector
        |> Enum.map(fn vector_item ->
          {vector_item.result, vector_item.frequency, model_data.model}
        end)
      end)

    # Group by result and calculate confidence score
    all_confidence_scores =
      all_result_frequencies
      |> Enum.group_by(fn {result, _freq, _model} -> result end)
      |> Enum.map(fn {result, occurrences} ->
        # Calculate how many models produced this result (weighted by their consistency)
        total_frequency = Enum.reduce(occurrences, 0.0, fn {_result, freq, _model}, acc ->
          acc + freq
        end)

        # Average frequency across all models
        confidence_score = total_frequency / length(queries_by_model)

        # Which models produced this result
        models_with_result = Enum.map(occurrences, fn {_result, freq, model} ->
          %{model: model, frequency: freq}
        end)

        %{
          result: result,
          confidence_score: confidence_score,
          models_contributing: length(occurrences),
          models_with_result: models_with_result
        }
      end)
      |> Enum.sort_by(& &1.confidence_score, :desc)

    # Take only the most confident result (first in sorted list) for backwards compatibility
    most_confident = List.first(all_confidence_scores)

    %{
      total_models: length(queries_by_model),
      unique_results: length(all_confidence_scores),
      most_confident_result: most_confident,
      all_confidence_scores: all_confidence_scores
    }
  end

  # From result array, compare each item to each other and build the consistency vector for these results
  #
  # return: consistency vector
  defp compare_results(results) do
    # Filter out error results
    valid_results = Enum.reject(results, fn result -> Map.get(result, :error, false) end)

    if Enum.empty?(valid_results) do
      # All queries failed
      %{
        total_queries: length(results),
        successful_queries: 0,
        failed_queries: length(results),
        unique_results: 0,
        consistency_vector: [],
        all_failed: true
      }
    else
      # Group identical results and count frequencies
      # Use direct structural comparison (no hashing)
      consistency_vector =
        valid_results
        |> Enum.group_by(fn result ->
          # Group by the normalized result structure
          %{
            columns: result.columns,
            rows: result.rows,
            row_count: result.row_count
          }
        end)
        |> Enum.map(fn {result_key, group} ->
          %{
            count: length(group),
            frequency: length(group) / length(valid_results),
            result: result_key
          }
        end)
        |> Enum.sort_by(& &1.frequency, :desc)

      %{
        total_queries: length(results),
        successful_queries: length(valid_results),
        failed_queries: length(results) - length(valid_results),
        unique_results: length(consistency_vector),
        consistency_vector: consistency_vector,
        all_failed: false
      }
    end
  end

  # Log evaluation results to CSV file
  defp log_to_csv(result, schema_info, question, _models, num_queries, run_id) do
    timestamp = DateTime.utc_now() |> DateTime.to_iso8601()

    schema_name = case schema_info do
      {:preset, name} -> name
      {:custom, _} -> "custom"
    end

    complexity = get_schema_complexity(schema_info)

    # Create CSV directory and header if file doesn't exist
    unless File.exists?(@csv_file_path) do
      @csv_file_path |> Path.dirname() |> File.mkdir_p!()
      header = "run_id,timestamp,schema_name,complexity,question,num_queries,model,consistency_score,successful_queries,failed_queries,unique_results,confidence_score,models_contributing,total_unique_confidence_results,is_tied,num_tied_results,model_result_rank\n"
      File.write!(@csv_file_path, header)
    end

    # Calculate tie information
    all_confidence_scores = result.confidence.all_confidence_scores || []
    highest_confidence = if length(all_confidence_scores) > 0 do
      List.first(all_confidence_scores).confidence_score
    else
      0.0
    end

    tied_results = Enum.filter(all_confidence_scores, fn score ->
      abs(score.confidence_score - highest_confidence) < 0.0001
    end)

    is_tied = length(tied_results) > 1
    num_tied_results = if is_tied, do: length(tied_results), else: 0

    # Write a row for each model
    Enum.each(result.models, fn model_result ->
      consistency_score = if length(model_result.consistency.consistency_vector) > 0 do
        model_result.consistency.consistency_vector
        |> List.first()
        |> Map.get(:frequency, 0.0)
      else
        0.0
      end

      confidence_score = if result.confidence.most_confident_result do
        result.confidence.most_confident_result.confidence_score
      else
        0.0
      end

      models_contributing = if result.confidence.most_confident_result do
        result.confidence.most_confident_result.models_contributing
      else
        0
      end

      # Find which rank this model's result achieved
      # Get the most common result for this model
      model_top_result = if length(model_result.consistency.consistency_vector) > 0 do
        List.first(model_result.consistency.consistency_vector).result
      else
        nil
      end

      model_result_rank = if model_top_result do
        Enum.find_index(all_confidence_scores, fn conf_score ->
          conf_score.result == model_top_result
        end)
        |> case do
          nil -> 0
          index -> index + 1  # Convert 0-based index to 1-based rank
        end
      else
        0
      end

      # Escape fields that might contain commas or quotes
      escaped_question = escape_csv_field(question)
      escaped_model = escape_csv_field(model_result.model)

      row = "#{run_id},#{timestamp},#{schema_name},#{complexity},#{escaped_question},#{num_queries},#{escaped_model},#{consistency_score},#{model_result.consistency.successful_queries},#{model_result.consistency.failed_queries},#{model_result.consistency.unique_results},#{confidence_score},#{models_contributing},#{result.confidence.unique_results},#{is_tied},#{num_tied_results},#{model_result_rank}\n"

      File.write!(@csv_file_path, row, [:append])
    end)
  end

  # Log consistency progression at each checkpoint for each model
  defp log_progression_csv(run_id, schema_info, question, queries_by_model, checkpoints) do
    schema_name = case schema_info do
      {:preset, name} -> name
      {:custom, _} -> "custom"
    end

    complexity = get_schema_complexity(schema_info)

    # Create CSV directory and header if file doesn't exist
    unless File.exists?(@progression_csv_path) do
      @progression_csv_path |> Path.dirname() |> File.mkdir_p!()
      header = "run_id,schema_name,complexity,question,model,checkpoint,consistency_score,successful_queries,failed_queries,unique_results\n"
      File.write!(@progression_csv_path, header)
    end

    escaped_question = escape_csv_field(question)

    Enum.each(queries_by_model, fn model_data ->
      escaped_model = escape_csv_field(model_data.model)

      Enum.each(checkpoints, fn checkpoint ->
        # Only compute if we have enough results
        if length(model_data.results) >= checkpoint do
          # Take the first N results and compute consistency at this checkpoint
          checkpoint_results = Enum.take(model_data.results, checkpoint)
          checkpoint_consistency = compare_results(checkpoint_results)

          consistency_score = if length(checkpoint_consistency.consistency_vector) > 0 do
            checkpoint_consistency.consistency_vector
            |> List.first()
            |> Map.get(:frequency, 0.0)
          else
            0.0
          end

          row = "#{run_id},#{schema_name},#{complexity},#{escaped_question},#{escaped_model},#{checkpoint},#{consistency_score},#{checkpoint_consistency.successful_queries},#{checkpoint_consistency.failed_queries},#{checkpoint_consistency.unique_results}\n"

          File.write!(@progression_csv_path, row, [:append])
        end
      end)
    end)
  end

  # Read complexity from schema's metadata.json
  defp get_schema_complexity(schema_info) do
    case schema_info do
      {:preset, schema_name} ->
        metadata_path = Path.join([:code.priv_dir(:backend), "static", "schemas", schema_name, "metadata.json"])
        case File.read(metadata_path) do
          {:ok, content} ->
            case Jason.decode(content) do
              {:ok, %{"complexity" => complexity}} -> complexity
              _ -> "unknown"
            end
          _ -> "unknown"
        end
      {:custom, _} -> "unknown"
    end
  end

  # Escape CSV fields that contain commas, quotes, or newlines
  defp escape_csv_field(field) when is_binary(field) do
    if String.contains?(field, [",", "\"", "\n"]) do
      escaped = String.replace(field, "\"", "\"\"")
      "\"#{escaped}\""
    else
      field
    end
  end

  # Log current run data to a separate CSV that gets overwritten each run
  # This is used for single-run visualizations
  defp log_current_run_csv(result) do
    # Ensure the directory exists
    @current_run_csv_path |> Path.dirname() |> File.mkdir_p!()

    # Calculate tie information
    all_confidence_scores = result.confidence.all_confidence_scores || []
    highest_confidence = if length(all_confidence_scores) > 0 do
      List.first(all_confidence_scores).confidence_score
    else
      0.0
    end

    # Write header and data (overwriting the file)
    header = "model,consistency_score,successful_queries,failed_queries,unique_results,total_queries,model_result_rank,is_top_result\n"

    rows = Enum.map(result.models, fn model_result ->
      consistency_score = if length(model_result.consistency.consistency_vector) > 0 do
        model_result.consistency.consistency_vector
        |> List.first()
        |> Map.get(:frequency, 0.0)
      else
        0.0
      end

      # Find which rank this model's result achieved
      model_top_result = if length(model_result.consistency.consistency_vector) > 0 do
        List.first(model_result.consistency.consistency_vector).result
      else
        nil
      end

      model_result_rank = if model_top_result do
        Enum.find_index(all_confidence_scores, fn conf_score ->
          conf_score.result == model_top_result
        end)
        |> case do
          nil -> 0
          index -> index + 1
        end
      else
        0
      end

      is_top_result = model_result_rank == 1

      escaped_model = escape_csv_field(model_result.model)

      "#{escaped_model},#{consistency_score},#{model_result.consistency.successful_queries},#{model_result.consistency.failed_queries},#{model_result.consistency.unique_results},#{model_result.consistency.total_queries},#{model_result_rank},#{is_top_result}\n"
    end)

    content = header <> Enum.join(rows, "")
    File.write!(@current_run_csv_path, content)
  end

end
