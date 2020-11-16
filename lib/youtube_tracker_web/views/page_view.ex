defmodule YoutubeTrackerWeb.PageView do
  use YoutubeTrackerWeb, :view

  @doc """
  Function for getting all the video's from a user's tracked channels
  """
  def videos(conn) do
    user = Guardian.Plug.current_resource(conn)
    channels = user.channels

    for %{
          videos: videos
        } <- channels do
      videos
    end
    |> List.flatten()
    |> Enum.sort_by(fn video -> video.published_at end)
  end

  def truncate_description(string, length) do
    "#{string |> String.slice(0, length) |> String.trim_trailing()}..."
  end
end
