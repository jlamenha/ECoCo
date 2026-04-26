defmodule BackendWeb.EvaluationController do
  use BackendWeb, :controller

  alias Backend.Evals

  def index(conn, _params) do
    json(conn, %{status: "evals hit"})
  end

  def list_models(conn, _params) do
    case OpenRouter.fetch_models() do
      {:ok, %{"data" => models}} when is_list(models) ->
        filtered =
          models
          |> Enum.filter(fn model ->
            input_modalities  = get_in(model, ["architecture", "input_modalities"])  || []
            output_modalities = get_in(model, ["architecture", "output_modalities"]) || []

            "text" in input_modalities and "text" in output_modalities
          end)
          |> Enum.map(fn model ->
            %{
              "id" => model["id"],
              "name" => model["name"]
            }
          end)

        json(conn, filtered)

      {:ok, models} when is_list(models) ->
        filtered =
          models
          |> Enum.filter(fn model ->
            input_modalities  = get_in(model, ["architecture", "input_modalities"])  || []
            output_modalities = get_in(model, ["architecture", "output_modalities"]) || []

            "text" in input_modalities and "text" in output_modalities
          end)
          |> Enum.map(fn model ->
            %{
              "id" => model["id"],
              "name" => model["name"]
            }
          end)

        json(conn, filtered)

      {:ok, other} ->
        json(conn, %{error: "Unexpected response shape", body: other})

      {:error, reason} ->
        json(conn, %{error: inspect(reason)})
    end
  end

  def list_schemas(conn, _params) do
    schemas_path = Path.join([
      :code.priv_dir(:backend),
      "static",
      "schemas"
    ])

    case File.ls(schemas_path) do
      {:ok, entries} ->
        # Filter to only include directories
        schemas = entries
        |> Enum.filter(fn entry ->
          full_path = Path.join(schemas_path, entry)
          File.dir?(full_path)
        end)
        |> Enum.sort()

        json(conn, %{schemas: schemas})

      {:error, :enoent} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Schemas directory not found"})

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Failed to list schemas: #{inspect(reason)}"})
    end
  end

  def get_schema(conn, %{"id" => schema_id}) do
    schema_dir = Path.join([
      :code.priv_dir(:backend),
      "static",
      "schemas",
      schema_id
    ])

    # Check if the schema directory exists
    unless File.dir?(schema_dir) do
      conn
      |> put_status(:not_found)
      |> json(%{error: "Schema '#{schema_id}' not found"})
    else
      init_path = Path.join(schema_dir, "init.sql")
      seed_path = Path.join(schema_dir, "seed.sql")

      # Read both files
      init_result = File.read(init_path)
      seed_result = File.read(seed_path)

      case {init_result, seed_result} do
        {{:ok, init_content}, {:ok, seed_content}} ->
          json(conn, %{
            id: schema_id,
            init: init_content,
            seed: seed_content
          })

        {{:error, :enoent}, _} ->
          conn
          |> put_status(:not_found)
          |> json(%{error: "init.sql not found for schema '#{schema_id}'"})

        {_, {:error, :enoent}} ->
          conn
          |> put_status(:not_found)
          |> json(%{error: "seed.sql not found for schema '#{schema_id}'"})

        {{:error, reason}, _} ->
          conn
          |> put_status(:internal_server_error)
          |> json(%{error: "Failed to read init.sql: #{inspect(reason)}"})

        {_, {:error, reason}} ->
          conn
          |> put_status(:internal_server_error)
          |> json(%{error: "Failed to read seed.sql: #{inspect(reason)}"})
      end
    end
  end


  def confidence_eval(conn, body) do
    %{
      "question" => question,
      "models" => models,
      "num_queries" => num_queries
    } = body

    # Handle num_queries as either string or integer
    num_queries_int = case num_queries do
      n when is_integer(n) -> n
      n when is_binary(n) -> String.to_integer(n)
    end

    # Determine schema source (preset or custom)
    schema_info = case body do
      %{"set_schema" => schema_name} ->
        {:preset, schema_name}

      %{"custom_schema" => custom_schema} ->
        {:custom, custom_schema}

      _ ->
        {:error, "Either 'set_schema' or 'custom_schema' must be provided"}
    end

    case schema_info do
      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})

      {:preset, schema_name} ->
        case load_schema_from_file(schema_name) do
          {:error, reason} ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: reason})

          schema_ddl ->
            result = Evals.confidence_eval(schema_ddl, question, models, num_queries_int, {:preset, schema_name}, [])
            json(conn, %{confidence: result})
        end

      {:custom, schema_ddl} ->
        result = Evals.confidence_eval(schema_ddl, question, models, num_queries_int, {:custom, schema_ddl}, [])
        json(conn, %{confidence: result})
    end
  end

  defp load_schema_from_file(schema_name) do
    schema_path = Path.join([
      :code.priv_dir(:backend),
      "static",
      "schemas",
      schema_name,
      "init.sql"
    ])

    case File.read(schema_path) do
      {:ok, content} ->
        content

      {:error, :enoent} ->
        {:error, "Schema '#{schema_name}' not found"}

      {:error, reason} ->
        {:error, "Failed to read schema: #{inspect(reason)}"}
    end
  end

  def generate_statistics(conn, %{"confidence" => confidence_data}) do
    # Write the evaluation data to CSV first
    write_statistics_csv(confidence_data)

    # Path to the Python script
    # In Docker: mounted at /analysis
    # Locally: relative to project root (parent of backend)
    {script_path, working_dir} = if File.exists?("/analysis/single_run_visualizations.py") do
      # Docker environment
      {"/analysis/single_run_visualizations.py", "/app"}
    else
      # Local development - find project root relative to priv directory
      priv_dir = :code.priv_dir(:backend) |> to_string()
      # priv_dir is like /path/to/backend/priv or /path/to/backend/_build/dev/lib/backend/priv
      project_root = priv_dir
        |> Path.dirname()  # Remove "priv"
        |> Path.dirname()  # Remove "backend" or go up in _build path
        |> then(fn path ->
          if String.contains?(path, "_build") do
            # In _build, need to go up more levels: _build/dev/lib/backend -> backend -> project_root
            path |> Path.dirname() |> Path.dirname() |> Path.dirname() |> Path.dirname()
          else
            path  # Already at project root
          end
        end)

      {Path.join([project_root, "analysis", "single_run_visualizations.py"]), project_root}
    end

    # Check if the script exists
    unless File.exists?(script_path) do
      conn
      |> put_status(:not_found)
      |> json(%{error: "Visualization script not found at #{script_path}"})
    else
      # Run the Python script
      case System.cmd("python3", [script_path], stderr_to_stdout: true, cd: working_dir) do
        {output, 0} ->
          # Get the list of generated figures
          figures_dir = Path.join([
            :code.priv_dir(:backend),
            "static",
            "figures"
          ])

          figures = case File.ls(figures_dir) do
            {:ok, files} ->
              files
              |> Enum.filter(&String.starts_with?(&1, "run_"))
              |> Enum.filter(&String.ends_with?(&1, ".png"))
              |> Enum.sort()

            {:error, _} ->
              []
          end

          json(conn, %{
            success: true,
            figures: figures,
            output: output
          })

        {error_output, exit_code} ->
          conn
          |> put_status(:internal_server_error)
          |> json(%{
            error: "Python script failed",
            exit_code: exit_code,
            output: error_output
          })
      end
    end
  end

  @doc """
  Batch evaluation endpoint for automated data gathering.
  Accepts a list of evaluation configurations and runs them sequentially.
  Results are automatically logged to evaluation_results.csv.

  Request body:
  {
    "models": ["model1", "model2"],
    "num_queries": 10,
    "checkpoints": [1, 3, 5, 7, 10],
    "evaluations": [
      {
        "schema": "schema_name",
        "question": "Your question here",
        "num_queries": 5  // optional, overrides top-level num_queries
      },
      ...
    ]
  }
  """
  def batch_eval(conn, %{"models" => models, "evaluations" => evaluations} = params) do
    require Logger

    checkpoints = Map.get(params, "checkpoints", [])
    default_num_queries = Map.get(params, "num_queries", 5)

    total = length(evaluations)
    Logger.info("Starting batch evaluation of #{total} configurations with #{length(models)} models")

    results = evaluations
    |> Enum.with_index(1)
    |> Enum.map(fn {eval_config, index} ->
      schema_name = eval_config["schema"]
      question = eval_config["question"]
      num_queries = eval_config["num_queries"] || default_num_queries

      num_queries_int = case num_queries do
        n when is_integer(n) -> n
        n when is_binary(n) -> String.to_integer(n)
      end

      Logger.info("[#{index}/#{total}] Running: schema=#{schema_name}, question=#{String.slice(question, 0..50)}...")

      case load_schema_from_file(schema_name) do
        {:error, reason} ->
          Logger.error("[#{index}/#{total}] Failed: #{reason}")
          %{
            index: index,
            schema: schema_name,
            question: question,
            status: "error",
            error: reason
          }

        schema_ddl ->
          try do
            result = Evals.confidence_eval(schema_ddl, question, models, num_queries_int, {:preset, schema_name}, checkpoints)
            Logger.info("[#{index}/#{total}] Completed successfully")

            {total_queries, failed_queries} =
              Enum.reduce(result.models, {0, 0}, fn model_data, {tot, fail} ->
                {tot + model_data.consistency.total_queries,
                 fail + model_data.consistency.failed_queries}
              end)

            %{
              index: index,
              schema: schema_name,
              question: question,
              num_queries: num_queries_int,
              status: "success",
              total_queries: total_queries,
              failed_queries: failed_queries
            }
          rescue
            e ->
              Logger.error("[#{index}/#{total}] Failed with exception: #{Exception.message(e)}")
              %{
                index: index,
                schema: schema_name,
                question: question,
                status: "error",
                error: Exception.message(e)
              }
          end
      end
    end)

    total_queries = Enum.reduce(results, 0, fn r, acc -> acc + Map.get(r, :total_queries, 0) end)
    failed_queries = Enum.reduce(results, 0, fn r, acc -> acc + Map.get(r, :failed_queries, 0) end)
    successful_queries = total_queries - failed_queries

    Logger.info("Batch evaluation complete: #{successful_queries}/#{total_queries} queries successful, #{failed_queries} failed")

    json(conn, %{
      total: total_queries,
      successful: successful_queries,
      failed: failed_queries,
      models: models,
      results: results
    })
  end

  # Write evaluation data to CSV for Python visualization
  defp write_statistics_csv(confidence_data) do
    csv_path = Path.join([:code.priv_dir(:backend), "static", "csv", "current_run.csv"])

    # Ensure directory exists
    csv_path |> Path.dirname() |> File.mkdir_p!()

    # Get all confidence scores to determine rankings
    all_confidence_scores = get_in(confidence_data, ["confidence", "all_confidence_scores"]) || []

    # Write header and data
    header = "model,consistency_score,successful_queries,failed_queries,unique_results,total_queries,model_result_rank,is_top_result\n"

    rows = Enum.map(confidence_data["models"] || [], fn model_result ->
      consistency_vector = get_in(model_result, ["consistency", "consistency_vector"]) || []

      consistency_score = if length(consistency_vector) > 0 do
        List.first(consistency_vector)["frequency"] || 0.0
      else
        0.0
      end

      # Find this model's top result
      model_top_result = if length(consistency_vector) > 0 do
        List.first(consistency_vector)["result"]
      else
        nil
      end

      # Find rank in confidence scores
      model_result_rank = if model_top_result do
        Enum.find_index(all_confidence_scores, fn conf_score ->
          conf_score["result"] == model_top_result
        end)
        |> case do
          nil -> 0
          index -> index + 1
        end
      else
        0
      end

      is_top_result = model_result_rank == 1

      model_name = model_result["model"] || ""
      escaped_model = if String.contains?(model_name, [",", "\"", "\n"]) do
        escaped = String.replace(model_name, "\"", "\"\"")
        "\"#{escaped}\""
      else
        model_name
      end

      successful = get_in(model_result, ["consistency", "successful_queries"]) || 0
      failed = get_in(model_result, ["consistency", "failed_queries"]) || 0
      unique = get_in(model_result, ["consistency", "unique_results"]) || 0
      total = get_in(model_result, ["consistency", "total_queries"]) || 0

      "#{escaped_model},#{consistency_score},#{successful},#{failed},#{unique},#{total},#{model_result_rank},#{is_top_result}\n"
    end)

    content = header <> Enum.join(rows, "")
    File.write!(csv_path, content)
  end
end
