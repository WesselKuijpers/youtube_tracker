defmodule YoutubeTracker.Repo.Migrations.AlterChannelsTable do
  use Ecto.Migration

  def change do
    alter table(:channels) do
      modify :description, :text
    end
  end
end
