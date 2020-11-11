defmodule YoutubeTracker.Channels.UsersChannels do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_channels" do
    belongs_to :user, YoutubeTracker.Accounts.User
    belongs_to :channel, YoutubeTracker.Channels.Channel

    timestamps()
  end

  @doc false
  def changeset(users_channels, attrs) do
    users_channels
    |> cast(attrs, [:user_id, :channel_id])
    |> validate_required([:user_id, :channel_id])
  end
end
