defmodule YoutubeTracker.Channels do
  @moduledoc """
  The Channels context.
  """

  import Ecto.Query, warn: false
  alias YoutubeTracker.Repo

  alias YoutubeTracker.Channels.Channel
  alias YoutubeTracker.Accounts.User
  alias YoutubeTracker.Accounts
  alias YoutubeTracker.Channels

  alias YoutubeTrackerWeb.YoutubeHelper

  @doc """
  Returns the list of channels.

  ## Examples

      iex> list_channels()
      [%Channel{}, ...]

  """
  def list_channels do
    Channel
    |> Repo.all()
    |> Repo.preload(:videos)
  end

  @doc """
  Gets a single channel.

  Raises `Ecto.NoResultsError` if the Channel does not exist.

  ## Examples

      iex> get_channel!(123)
      %Channel{}

      iex> get_channel!(456)
      ** (Ecto.NoResultsError)

  """
  def get_channel!(id) do
    Channel
    |> Repo.get!(id)
    |> Repo.preload(:videos)
  end

  @doc """
  Gets a single channel, by its youtube id.
  """
  def get_channel_by_youtube_id!(youtube_id),
    do: Repo.one(from c in Channel, where: c.youtube_id == ^youtube_id)

  @doc """
  Creates a channel, if it doesn't exist yet. Associate it with user

  ## Examples

      iex> create_channel(%{field: value})
      {:ok, %Channel{}}

      iex> create_channel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_channel(attrs \\ %{}, %User{} = user) do
    # see if the requested channel exist
    case Channels.get_channel_by_youtube_id!(attrs["youtube_id"]) do
      nil ->
        #  if not, create and associate
        attrs = YoutubeHelper.expand_channel_attrs(attrs)

        %Channel{}
        |> Channel.changeset(attrs)
        |> Repo.insert()
        |> YoutubeHelper.get_channel_videos()
        |> Accounts.add_channel_to_user(user)

      channel ->
        # else, associate it
        Accounts.add_channel_to_user(channel, user)
    end
  end

  @doc """
  Updates a channel.

  ## Examples

      iex> update_channel(channel, %{field: new_value})
      {:ok, %Channel{}}

      iex> update_channel(channel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_channel(%Channel{} = channel, attrs) do
    channel
    |> Channel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a channel.

  ## Examples

      iex> delete_channel(channel)
      {:ok, %Channel{}}

      iex> delete_channel(channel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_channel(%Channel{} = channel) do
    Repo.delete(channel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking channel changes.

  ## Examples

      iex> change_channel(channel)
      %Ecto.Changeset{data: %Channel{}}

  """
  def change_channel(%Channel{} = channel, attrs \\ %{}) do
    Channel.changeset(channel, attrs)
  end

  alias YoutubeTracker.Channels.Video

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def list_videos do
    Video
    |> Repo.all()
    |> Repo.preload(:channel)
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id) do
    Video
    |> Repo.get!(id)
    |> Repo.preload(:channel)
  end

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(attrs \\ %{}, %Channel{} = channel) do
    %Video{}
    |> Video.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:channel, channel)
    |> Repo.insert()
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  def delete_videos(%Channel{} = channel) do
    delete_videos(channel.videos)
  end

  def delete_videos([head | tail]) do
    delete_video(head)
    delete_videos(tail)
  end

  def delete_videos([]) do
    :ok
  end

  @doc """
  Deletes a video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{data: %Video{}}

  """
  def change_video(%Video{} = video, attrs \\ %{}) do
    Video.changeset(video, attrs)
  end
end
