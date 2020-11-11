defmodule YoutubeTracker.Repo.Migrations.CreateUsersChannels do
  use Ecto.Migration

  def change do
    create table(:users_channels) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :channel_id, references(:channels, on_delete: :delete_all)

      timestamps()
    end

    create index(:users_channels, [:user_id])
    create index(:users_channels, [:channel_id])
  end
end
