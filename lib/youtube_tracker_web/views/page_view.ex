defmodule YoutubeTrackerWeb.PageView do
  use YoutubeTrackerWeb, :view
  alias YoutubeTracker.Accounts
  alias YoutubeTrackerWeb.{UserView, SessionView}
  alias YoutubeTracker.Accounts

  def current_user(conn) do
    Accounts.get_user!(Plug.Conn.get_session(conn, "user_id"))
  end
end
