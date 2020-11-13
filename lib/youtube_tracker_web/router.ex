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

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", YoutubeTrackerWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    post "/users", UserController, :create

    resources "/sessions", SessionController,
      only: [:create, :delete],
      singleton: true
  end

  scope "/", YoutubeTrackerWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    resources "/channels", ChannelController, only: [:create, :show]
    post "/channels/search", ChannelController, :search
  end
end
