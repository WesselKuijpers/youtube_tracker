defmodule YoutubeTracker.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :youtubeID, :string
      add :title, :string
      add :description, :string
      add :image_url, :string

      timestamps()
    end
  end
end
