defmodule YoutubeTrackerWeb.APIHelper do
  def make_call(base_link, params) do
    base_link
    |> build_link(params)
    |> get_response(:atoms)
  end

  def get_response(link, keys) do
    link
    |> HTTPoison.get()
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

  def build_link(base_link, [head | tail] = _params) do
    base_link
    |> check_for_questionmark
    |> build_link(head)
    |> build_link(tail)
  end

  def build_link(base_link, []) do
    base_link
  end

  def build_link(base_link, {key, value} = _param) do
    "#{base_link}&#{Atom.to_string(key)}=#{value}"
  end

  def check_for_questionmark(base_link) do
    case String.slice(base_link, String.length(base_link) - 1, 1) do
      "?" ->
        base_link

      _ ->
        case base_link =~ "=" do
          true -> base_link
          false -> base_link <> "?"
        end
    end
  end
end
