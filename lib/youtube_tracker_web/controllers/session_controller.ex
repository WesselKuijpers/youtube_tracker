defmodule YoutubeTrackerWeb.SessionController do
  use YoutubeTrackerWeb, :controller

  alias YoutubeTracker.Accounts
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias YoutubeTrackerWeb.GuardianSerializer

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    user = Accounts.authenticate_by_email(email)

    result = cond do
      user && checkpw(password, user.credential.password_hash) ->
        {:ok, GuardianSerializer.Plug.sign_in(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end

    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Successfully logged in!")
        |> redirect(to: "/")
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> redirect(to: "/")
    end
  end

  def delete(conn, _) do
    conn
    |> GuardianSerializer.Plug.sign_out()
    |> redirect(to: "/")
  end
end
