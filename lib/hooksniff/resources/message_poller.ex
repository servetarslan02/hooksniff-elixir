defmodule HookSniff.MessagePoller do
  @moduledoc "Message polling — poll, seek, commit."

  alias HookSniff.Client

  @doc "Poll for messages"
  @spec poll(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def poll(client, params \\ %{}) do
    path = build_query("/api/v1/message-poller/poll", params)
    Client.request(:get, path, nil, client)
  end

  @doc "Seek cursor"
  @spec seek(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def seek(client, params), do: Client.request(:post, "/api/v1/message-poller/seek", params, client)

  @doc "Commit cursor"
  @spec commit(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def commit(client, params), do: Client.request(:post, "/api/v1/message-poller/commit", params, client)

  defp build_query(path, params) when params == %{}, do: path
  defp build_query(path, params) do
    query = params |> Enum.map(fn {k, v} -> "#{k}=#{URI.encode_www_form(to_string(v))}" end) |> Enum.join("&")
    "#{path}?#{query}"
  end
end
