defmodule YoutubeTrackerWeb.Router do
  use YoutubeTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug YoutubeTracker.UserManager.Pipeline
    plug YoutubeTracker.CurrentUser
  end

  # pipeline :with_session do
  #   plug Guardian.Plug.Pipeline, module: GuardianSerializer, error_handler: YoutubeTracker.AuthErrorHandler
  #   plug Guardian.Plug.VerifySession
  #   plug Guardian.Plug.LoadResource
  #   plug YoutubeTracker.CurrentUser
  # end

  scope "/", YoutubeTrackerWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    post "/users", UserController, :create

    resources "/sessions", SessionController,
      only: [:create, :delete],
      singleton: true

    resources "/channels", ChannelController, only: [:create, :show]
    post "/channels/search", ChannelController, :search
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "login required!")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()

      user_id ->
        assign(conn, :current_user, YoutubeTracker.Accounts.get_user!(user_id))
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", YoutubeTrackerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: YoutubeTrackerWeb.Telemetry
    end
  end
end
