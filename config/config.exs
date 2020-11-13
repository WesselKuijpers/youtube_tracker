# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :youtube_tracker,
  ecto_repos: [YoutubeTracker.Repo]

# Configures the endpoint
config :youtube_tracker, YoutubeTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dh1uWAlMCVMUSja3x/5grQMC8QuRtfkzG8GGRfsgpORWFQd/Faw08DP8hXCqUMFp",
  render_errors: [view: YoutubeTrackerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: YoutubeTracker.PubSub,
  live_view: [signing_salt: "ZyNtgAJ7"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

import_config "secrets.exs"
