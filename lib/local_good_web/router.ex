defmodule LocalGoodWeb.Router do
  use LocalGoodWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LocalGoodWeb do
    get "/", PageController, :index
  end

  scope "/app", LocalGoodWeb do
    get "/", WebappController, :index
    get "/*path", WebappController, :index
  end

  scope "/api", LocalGoodWeb do
    pipe_through :api
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:local_good, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: LocalGoodWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
