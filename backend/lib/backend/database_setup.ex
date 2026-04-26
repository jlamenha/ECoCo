defmodule Backend.DatabaseSetup do
  @moduledoc """
  Handles dynamic database setup for evaluation schemas.
  Creates temporary schemas, runs DDL and seed scripts.
  """

  alias Backend.Repo

  @doc """
  Sets up a database schema by running init.sql and seed.sql.
  Returns the schema name that was created.
  """
  def setup_schema(schema_name) when is_binary(schema_name) do
    init_path = Path.join([
      :code.priv_dir(:backend),
      "static",
      "schemas",
      schema_name,
      "init.sql"
    ])

    seed_path = Path.join([
      :code.priv_dir(:backend),
      "static",
      "schemas",
      schema_name,
      "seed.sql"
    ])

    with {:ok, init_sql} <- File.read(init_path),
         {:ok, seed_sql} <- File.read(seed_path) do
      execute_setup_scripts(init_sql, seed_sql, schema_name)
    else
      {:error, :enoent} ->
        {:error, "Schema files not found for '#{schema_name}'"}

      {:error, reason} ->
        {:error, "Failed to read schema files: #{inspect(reason)}"}
    end
  end

  @doc """
  Sets up a database schema using custom DDL.
  Since there's no seed data for custom schemas, it only runs the DDL.
  """
  def setup_custom_schema(ddl) when is_binary(ddl) do
    # Generate a unique schema name for this custom schema
    schema_name = "custom_#{:erlang.unique_integer([:positive])}"

    execute_setup_scripts(ddl, nil, schema_name)
  end

  defp execute_setup_scripts(init_sql, seed_sql, schema_name) do
    # Drop the schema if it exists (cleanup from previous runs)
    Ecto.Adapters.SQL.query!(Repo, "DROP SCHEMA IF EXISTS #{schema_name} CASCADE")

    # Create the schema fresh
    Ecto.Adapters.SQL.query!(Repo, "CREATE SCHEMA #{schema_name}")

    # Split and execute DDL statements
    init_sql
    |> split_sql_statements()
    |> Enum.each(fn statement ->
      unless String.trim(statement) == "" do
        Ecto.Adapters.SQL.query!(Repo, statement)
      end
    end)

    # Run the seed data if provided
    if seed_sql do
      seed_sql
      |> split_sql_statements()
      |> Enum.each(fn statement ->
        unless String.trim(statement) == "" do
          Ecto.Adapters.SQL.query!(Repo, statement)
        end
      end)
    end

    {:ok, schema_name}
  rescue
    e in Postgrex.Error ->
      {:error, "Database error: #{Exception.message(e)}"}

    e ->
      {:error, "Unexpected error: #{Exception.message(e)}"}
  end

  defp split_sql_statements(sql) do
    sql
    # Remove comment lines
    |> String.split("\n")
    |> Enum.reject(&String.starts_with?(String.trim(&1), "--"))
    |> Enum.join("\n")
    # Split by semicolon
    |> String.split(";")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  @doc """
  Drops a schema and all its tables.
  Use this to clean up after running queries.
  """
  def cleanup_schema(schema_name) when is_binary(schema_name) do
    Ecto.Adapters.SQL.query!(
      Repo,
      "DROP SCHEMA IF EXISTS #{schema_name} CASCADE"
    )

    :ok
  rescue
    e ->
      require Logger
      Logger.error("Failed to cleanup schema #{schema_name}: #{inspect(e)}")
      {:error, "Cleanup failed"}
  end
end
