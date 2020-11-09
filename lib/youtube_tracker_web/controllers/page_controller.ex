defmodule YoutubeTrackerWeb.PageController do
  use YoutubeTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
