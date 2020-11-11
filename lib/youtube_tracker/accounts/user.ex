defmodule YoutubeTracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias YoutubeTracker.Accounts.Credential

  schema "users" do
    field :name, :string
    field :username, :string
    has_one :credential, Credential

    many_to_many(:channels, YoutubeTracker.Channels.Channel,
      join_through: YoutubeTracker.Channels.UsersChannels
    )

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> unique_constraint(:username)
  end
end
