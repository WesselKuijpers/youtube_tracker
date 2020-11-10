defmodule YoutubeTrackerWeb.SessionController do
  use YoutubeTrackerWeb, :controller

  alias YoutubeTracker.Accounts

  def create(conn, %{"user" => %{"email" => email}}) do
    case Accounts.authenticate_by_email(email) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Showing tracked channels for: #{user.username}")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Could not find user.")
        |> redirect(to: "/")
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
