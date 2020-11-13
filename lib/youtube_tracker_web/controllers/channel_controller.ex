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
    user = Guardian.Plug.current_resource(conn)
    case Channels.create_channel(channel_params, user) do
      {:ok, channel} ->
        conn
        |> put_flash(:info, "Channel '#{channel.title}' tracked successfully.")
        |> redirect(to: "/")
      {:error, _changeset} ->
        conn
        |> put_flash(:info, "Something went wrong while tracking.")
        |> redirect(to: "/")
    end
  end

  def show(conn, %{"id" => id}) do
    channel = Channels.get_channel!(id)
    render(conn, "show.html", channel: channel)
  end
end
