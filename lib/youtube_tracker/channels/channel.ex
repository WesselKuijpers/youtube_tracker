defmodule YoutubeTracker.Channels.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "channels" do
    field :description, :string
    field :image_url, :string
    field :title, :string
    field :youtube_id, :string
    many_to_many(:users, YoutubeTracker.Accounts.User, join_through: YoutubeTracker.Channels.UsersChannels)

    timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:youtube_id, :title, :description, :image_url])
    |> validate_required([:youtube_id, :title, :description, :image_url])
    |> unique_constraint([:youtube_id])
  end
end
