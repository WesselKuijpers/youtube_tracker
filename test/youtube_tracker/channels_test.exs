defmodule YoutubeTracker.ChannelsTest do
  use YoutubeTracker.DataCase

  alias YoutubeTracker.Channels

  describe "channels" do
    alias YoutubeTracker.Channels.Channel

    @valid_attrs %{
      description: "some description",
      image_url: "some image_url",
      title: "some title",
      youtubeID: "some youtubeID"
    }
    @update_attrs %{
      description: "some updated description",
      image_url: "some updated image_url",
      title: "some updated title",
      youtubeID: "some updated youtubeID"
    }
    @invalid_attrs %{description: nil, image_url: nil, title: nil, youtubeID: nil}

    def channel_fixture(attrs \\ %{}) do
      {:ok, channel} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Channels.create_channel()

      channel
    end

    test "list_channels/0 returns all channels" do
      channel = channel_fixture()
      assert Channels.list_channels() == [channel]
    end

    test "get_channel!/1 returns the channel with given id" do
      channel = channel_fixture()
      assert Channels.get_channel!(channel.id) == channel
    end

    test "create_channel/1 with valid data creates a channel" do
      assert {:ok, %Channel{} = channel} = Channels.create_channel(@valid_attrs)
      assert channel.description == "some description"
      assert channel.image_url == "some image_url"
      assert channel.title == "some title"
      assert channel.youtubeID == "some youtubeID"
    end

    test "create_channel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channels.create_channel(@invalid_attrs)
    end

    test "update_channel/2 with valid data updates the channel" do
      channel = channel_fixture()
      assert {:ok, %Channel{} = channel} = Channels.update_channel(channel, @update_attrs)
      assert channel.description == "some updated description"
      assert channel.image_url == "some updated image_url"
      assert channel.title == "some updated title"
      assert channel.youtubeID == "some updated youtubeID"
    end

    test "update_channel/2 with invalid data returns error changeset" do
      channel = channel_fixture()
      assert {:error, %Ecto.Changeset{}} = Channels.update_channel(channel, @invalid_attrs)
      assert channel == Channels.get_channel!(channel.id)
    end

    test "delete_channel/1 deletes the channel" do
      channel = channel_fixture()
      assert {:ok, %Channel{}} = Channels.delete_channel(channel)
      assert_raise Ecto.NoResultsError, fn -> Channels.get_channel!(channel.id) end
    end

    test "change_channel/1 returns a channel changeset" do
      channel = channel_fixture()
      assert %Ecto.Changeset{} = Channels.change_channel(channel)
    end
  end

  describe "videos" do
    alias YoutubeTracker.Channels.Video

    @valid_attrs %{
      description: "some description",
      published_at: ~D[2010-04-17],
      title: "some title",
      youtube_id: "some youtube_id"
    }
    @update_attrs %{
      description: "some updated description",
      published_at: ~D[2011-05-18],
      title: "some updated title",
      youtube_id: "some updated youtube_id"
    }
    @invalid_attrs %{description: nil, published_at: nil, title: nil, youtube_id: nil}

    def video_fixture(attrs \\ %{}) do
      {:ok, video} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Channels.create_video()

      video
    end

    test "list_videos/0 returns all videos" do
      video = video_fixture()
      assert Channels.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert Channels.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      assert {:ok, %Video{} = video} = Channels.create_video(@valid_attrs)
      assert video.description == "some description"
      assert video.published_at == ~D[2010-04-17]
      assert video.title == "some title"
      assert video.youtube_id == "some youtube_id"
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channels.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()
      assert {:ok, %Video{} = video} = Channels.update_video(video, @update_attrs)
      assert video.description == "some updated description"
      assert video.published_at == ~D[2011-05-18]
      assert video.title == "some updated title"
      assert video.youtube_id == "some updated youtube_id"
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = Channels.update_video(video, @invalid_attrs)
      assert video == Channels.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Channels.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Channels.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Channels.change_video(video)
    end
  end
end
