defmodule YoutubeTrackerWeb.PageView do
  use YoutubeTrackerWeb, :view
  alias YoutubeTracker.Accounts
  alias YoutubeTracker.Accounts

  def current_user(conn) do
    Accounts.get_user!(Plug.Conn.get_session(conn, "user_id"))
  end

  @doc """
  Function for getting all the video's from a user's tracked channels
  """
  def videos(conn) do
    user = current_user(conn)
    channels = user.channels
    for %{
      videos: videos
    } <- channels do
      videos
    end
    |> List.flatten()
  end
end
