defmodule YoutubeTrackerWeb.UserController do
  use YoutubeTrackerWeb, :controller

  alias YoutubeTracker.Accounts

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = _changeset} ->
        redirect(conn, to: "/")
    end
  end
end
