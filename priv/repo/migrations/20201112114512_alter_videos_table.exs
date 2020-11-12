defmodule YoutubeTracker.Repo.Migrations.AlterVideosTable do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      modify :description, :text
    end
  end
end
