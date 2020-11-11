defmodule YoutubeTrackerWeb.YoutubeHelper do
  alias YoutubeTrackerWeb.APIHelper

  def key do
    "AIzaSyDEhheLyAulQtshEK4SL5a7AZuXIDz3k8c"
  end

  def search_channels(query) do
    search_channels(query, 10)
  end

  def search_channels(query, 0) do
    search_channels(query)
  end

  def search_channels(query, "") do
    search_channels(query)
  end

  def search_channels(query, quantity) do
    base_link = "https://www.googleapis.com/youtube/v3/search"
    params = [
      q: query,
      part: "snippet",
      key: key(),
      type: "channel",
      maxResults: quantity
    ]

    APIHelper.make_call(base_link, params)
  end

  def map_channels(%{items: items}) do
    for %{id: %{channelId: id}, snippet: %{title: title, description: description, thumbnails: %{high: %{url: thumbnail_url}}}} <- items do
      [
        id: id,
        title: title,
        description: description,
        thumbnail_url: thumbnail_url
      ]
    end
  end
end
