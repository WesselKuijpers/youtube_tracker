defmodule YoutubeTracker.CurrentUser do
  @moduledoc """
  plug for making the current user more readily available
  """
  import Plug.Conn
  import Guardian.Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = current_resource(conn)
    assign(conn, :current_user, current_user)
  end
end
