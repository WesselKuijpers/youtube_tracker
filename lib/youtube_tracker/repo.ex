defmodule YoutubeTracker.Repo do
  use Ecto.Repo,
    otp_app: :youtube_tracker,
    adapter: Ecto.Adapters.Postgres
end
