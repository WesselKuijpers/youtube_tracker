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
end
