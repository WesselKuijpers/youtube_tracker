defmodule YoutubeTrackerWeb.APIHelper do
  @moduledoc """
  The APIHelper helps with making an api request.
  The intention is not to use this directly in a controller of a context,
  it is meant to be used in a different helper which can then be used in other places
  For instance: YoutubeHelper
  """

  @doc """
  Gets a decoded response from a webservice by link, a map of params and the type of keys you want the response body to be decoded with

  example:

  get_response(
    "https://www.googleapis.com/youtube/v3/search",
    %{
      q: "example"
      k: "YOURKEY"
      part: "snippet"
    },
    :atoms
  )
  """
  def get_response(link, %{} = params, keys) do
    link
    |> HTTPoison.get([], params: params)
    |> case do
      {:ok, %{body: raw, status_code: code}} -> {code, raw}
      {:error, %{reason: reason}} -> {:error, reason}
    end
    |> (fn {ok, body} ->
          body
          |> Poison.decode(keys: keys)
          |> case do
            {:ok, parsed} -> {ok, parsed}
            _ -> {:error, body}
          end
        end).()
  end
end
