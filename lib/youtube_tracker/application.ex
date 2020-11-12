defmodule YoutubeTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      YoutubeTracker.Repo,
      # Start the Telemetry supervisor
      YoutubeTrackerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: YoutubeTracker.PubSub},
      # Start the Endpoint (http/https)
      YoutubeTrackerWeb.Endpoint,
      # Start a worker by calling: YoutubeTracker.Worker.start_link(arg)
      # {YoutubeTracker.Worker, arg}
      YoutubeTracker.ChannelVideosUpdater
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: YoutubeTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    YoutubeTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
