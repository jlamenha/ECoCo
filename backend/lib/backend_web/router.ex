defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendWeb do
    pipe_through :api

    get "/health", HealthController, :index

    scope "/evaluate" do
      post "/healthcheck", EvaluationController, :index
      get "/list-models", EvaluationController, :list_models
      post "/", EvaluationController, :confidence_eval
      post "/batch", EvaluationController, :batch_eval
      get "/list-schemas", EvaluationController, :list_schemas
      post "/generate-statistics", EvaluationController, :generate_statistics
    end

    get "/schema/:id", EvaluationController, :get_schema
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:backend, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BackendWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
