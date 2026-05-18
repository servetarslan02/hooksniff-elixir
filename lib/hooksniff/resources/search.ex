defmodule HookSniff.Search do
  @moduledoc "Search webhook deliveries."

  alias HookSniff.Client

  @doc "Search deliveries"
  @spec search(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def search(client, params \\ %{}) do
    path = build_query("/api/v1/search", params)
    Client.request(:get, path, nil, client)
  end

  defp build_query(path, params) when params == %{}, do: path
  defp build_query(path, params) do
    query = params |> Enum.map(fn {k, v} -> "#{k}=#{URI.encode_www_form(to_string(v))}" end) |> Enum.join("&")
    "#{path}?#{query}"
  end
end
