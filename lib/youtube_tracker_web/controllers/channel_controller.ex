defmodule YoutubeTrackerWeb.ChannelController do
  use YoutubeTrackerWeb, :controller

  alias YoutubeTracker.Channels
  alias YoutubeTracker.Channels.Channel
  alias YoutubeTracker.Accounts
  alias YoutubeTrackerWeb.YoutubeHelper

  def search(conn, %{"query" => query, "quantity" => quantity}) do
    case YoutubeHelper.search_channels(query, quantity) do
      {200, response} ->
        results = YoutubeHelper.map_channels(response)
        changeset = Channels.change_channel(%Channel{})

        render(conn, "search_results.html", results: results, changeset: changeset)

      {code, _body} ->
        conn
        |> put_flash(:error, "An error occured while searching: #{code}")
        |> redirect(to: "/")
    end
  end

  def create(conn, %{"channel" => channel_params}) do
    user = Accounts.get_user!(get_session(conn, "user_id"))

    case Channels.get_channel_by_youtube_id!(channel_params["youtube_id"]) do
      nil ->
        case Channels.create_channel(channel_params) do
          {:ok, channel} ->
            Accounts.add_channel_to_user(channel, user)

            conn
            |> put_flash(:info, "Channel '#{channel.title}' tracked successfully.")
            |> redirect(to: "/")

          {:error, _changeset} ->
            conn
            |> put_flash(:info, "Something went wrong while tracking.")
            |> redirect(to: "/")
        end

      channel ->
        Accounts.add_channel_to_user(channel, user)

        conn
        |> put_flash(:info, "Channel '#{channel.title}' tracked successfully.")
        |> redirect(to: "/")
    end
  end
end
