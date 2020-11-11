defmodule YoutubeTrackerWeb.APIHelper do
  def get_response(link, params, keys) do
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
