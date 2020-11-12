defmodule YoutubeTrackerWeb.YoutubeHelper do
  alias YoutubeTrackerWeb.APIHelper
  alias YoutubeTracker.Channels.Channel
  alias YoutubeTracker.Channels

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

    params = %{
      q: query,
      part: "snippet",
      key: key(),
      type: "channel",
      maxResults: quantity
    }

    APIHelper.get_response(base_link, params, :atoms)
  end

  def map_channels(%{items: items}) do
    for %{
          id: %{channelId: id},
          snippet: %{
            title: title,
            description: description,
            thumbnails: %{high: %{url: thumbnail_url}}
          }
        } <- items do
      [
        id: id,
        title: title,
        description: description,
        thumbnail_url: thumbnail_url
      ]
    end
  end

  def get_channel(%Channel{youtube_id: id}) do
    base_link = "https://www.googleapis.com/youtube/v3/channels"

    params = %{
      part: "contentDetails",
      key: key(),
      id: id
    }

    APIHelper.get_response(base_link, params, :atoms)
  end

  def map_channel_playlist_id(%{items: [%{
    contentDetails: %{
      relatedPlaylists: %{
        uploads: uploads_playlist_id
      }
    }
  }]}) do
    uploads_playlist_id
  end

  def get_playlist_uploads_id({:ok, %Channel{} = channel}) do
    {200, response} = get_channel(channel)
    playlist_id = map_channel_playlist_id(response)
    Channel.changeset(channel, %{uploads_playlist_id: playlist_id})
  end

  def get_channel_videos(%Channel{} = channel) do
    base_link = "https://www.googleapis.com/youtube/v3/playlistItems"
    params = %{
      key: key(),
      part: "snippet",
      playlistId: channel.uploads_playlist_id,
      max_results: 10
    }

    APIHelper.get_response(base_link, params, :atoms)
    |> map_channel_videos()
    |> save_channel_videos(channel)
  end

  def get_channel_videos({:ok, channel}) do
    get_channel_videos(channel)
  end

  def map_channel_videos({200, %{items: items}}) do
    for %{
      snippet: %{
        publishedAt: published_at,
        title: title,
        description: description,
        resourceId: %{
          videoId: id
        }
      }
    } <- items do
      %{
        youtube_id: id,
        published_at: published_at,
        title: title,
        description: description
      }
    end
  end

  def save_channel_videos([video | videos], %Channel{} = channel) do
    save_channel_video(video, channel)
    save_channel_videos(videos, channel)
  end

  def save_channel_videos([], %Channel{} = channel) do
    {:ok, channel}
  end

  def save_channel_video(video, %Channel{} = channel) do
    Channels.create_video(video, channel)
  end
end
