defmodule YoutubeTrackerWeb.ChannelController do
  use YoutubeTrackerWeb, :controller

  alias YoutubeTracker.Channels
  alias YoutubeTracker.Channels.Channel
  alias YoutubeTrackerWeb.YoutubeHelper

  def search(conn, %{"query" => query, "quantity" => quantity}) do
    # use quesry to get search results from youtube, if succesfull render results else redirect back
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
    # possibly create, associates a channel with a user
    user = Guardian.Plug.current_resource(conn)
    channel = Channels.create_channel(channel_params, user)

    conn
    |> put_flash(:info, "Channel '#{channel.title}' tracked successfully.")
    |> redirect(to: "/")
  end

  def show(conn, %{"id" => id}) do
    channel = Channels.get_channel!(id)
    render(conn, "show.html", channel: channel)
  end
end
