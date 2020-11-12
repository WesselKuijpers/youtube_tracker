defmodule YoutubeTracker.Channels.Video do
  use Ecto.Schema
  import Ecto.Changeset

  alias YoutubeTracker.Channels.Channel

  schema "videos" do
    field :description, :string
    field :published_at, :date
    field :title, :string
    field :youtube_id, :string
    belongs_to :channel, Channel

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:youtube_id, :published_at, :title, :description])
    |> validate_required([:youtube_id, :published_at, :title, :description])
  end
end
