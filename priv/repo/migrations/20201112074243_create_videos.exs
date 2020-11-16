defmodule YoutubeTracker.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :youtube_id, :string
      add :published_at, :date
      add :title, :string
      add :description, :string
      add :channel_id, references(:channels, on_delete: :delete_all), null: true

      timestamps()
    end
  end
end
