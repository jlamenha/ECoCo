defmodule OpenRouter do
  @model_list "https://openrouter.ai/api/v1/models"

  def fetch_models do
    case Req.get(@model_list) do
      {:ok, %{body: %{"data" => models}}} ->
        {:ok, models}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
