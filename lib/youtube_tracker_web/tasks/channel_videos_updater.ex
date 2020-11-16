defmodule YoutubeTracker.ChannelVideosUpdater do
  @moduledoc """
  Task that runs every hour and updates the videolist for every tracked channel
  """

  use Task

  alias YoutubeTracker.Channels
  alias YoutubeTracker.Channels.Channel
  alias YoutubeTrackerWeb.YoutubeHelper

  def start_link(_arg) do
    Task.start_link(&schedule/0)
  end

  def schedule() do
    receive do
    after
      3600_000 ->
        refresh_videos()
        schedule()
    end
  end

  def refresh_videos() do
    Channels.list_channels()
    |> refresh_channels
  end

  def refresh_channels([head | tail]) do
    refresh_channel(head)
    refresh_channels(tail)
  end

  def refresh_channels([]) do
    :ok
  end

  def refresh_channel(%Channel{} = channel) do
    # deletes all a channels existing videos
    Channels.delete_videos(channel)
    # save newest videos
    YoutubeHelper.get_channel_videos(channel)
  end
end
