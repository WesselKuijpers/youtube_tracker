defmodule YoutubeTrackerWeb.YoutubeHelper do
  @moduledoc """
  The YoutubeHelper helps with making requests to the youtube API.
  It uses the api_helper to do this
  """

  alias YoutubeTrackerWeb.APIHelper
  alias YoutubeTracker.Channels.Channel
  alias YoutubeTracker.Channels

  def key do
    Application.get_env(:youtube_tracker, :youtube_key)
  end

  @doc """
  Searches youtube for the given query, returns as many results as quantity specifies
  Response still needs to be mapped to be usefull
  example:

  search_channels("example")
  search_channels("example", 10)
  """
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

  @doc """
  Maps the response from search_channels to a list of lists containing data
  for each channel that was found.
  Takes decoded json response
  """
  def map_channels(%{items: items}) do
    for %{
          id: %{channelId: id},
          snippet: %{
            title: title,
            description: description,
            thumbnails: %{medium: %{url: thumbnail_url}}
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

  def expand_channel_attrs(%{"youtube_id" => youtube_id}) do
    youtube_id
    |> get_channel
    |> map_channel
  end

  @doc """
  Takes a Channel and queries youtube for more data by the channel's youtube api
  """
  def get_channel(id) do
    base_link = "https://www.googleapis.com/youtube/v3/channels"

    params = %{
      part: "contentDetails,snippet",
      key: key(),
      id: id
    }

    {_response, body} = APIHelper.get_response(base_link, params, :atoms)
    body
  end

  @doc """
  takes the response from get_channel and extracts the uploads playlist id
  """
  def map_channel(%{
        items: [
          %{
            id: youtube_id,
            contentDetails: %{
              relatedPlaylists: %{
                uploads: uploads_playlist_id
              }
            },
            snippet: %{
              title: title,
              description: description,
              thumbnails: %{
                medium: %{
                  url: image_url
                }
              }
            }
          }
        ]
      }) do
    %{
      description: description,
      image_url: image_url,
      title: title,
      youtube_id: youtube_id,
      uploads_playlist_id: uploads_playlist_id
    }
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
    channel
  end

  def save_channel_video(video, %Channel{} = channel) do
    Channels.create_video(video, channel)
  end
end
