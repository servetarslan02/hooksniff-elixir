defmodule HookSniff.Stream do
  @moduledoc "Real-time streaming — channels, publish, subscriptions."

  alias HookSniff.Client

  @doc "List channels"
  @spec list_channels(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list_channels(client), do: Client.request(:get, "/v1/stream/channels", nil, client)

  @doc "Get a channel"
  @spec get_channel(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get_channel(client, id), do: Client.request(:get, "/v1/stream/channels/#{id}", nil, client)

  @doc "Create a channel"
  @spec create_channel(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create_channel(client, params), do: Client.request(:post, "/v1/stream/channels", params, client)

  @doc "Delete a channel"
  @spec delete_channel(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete_channel(client, id), do: Client.request(:delete, "/v1/stream/channels/#{id}", nil, client)

  @doc "Publish a message"
  @spec publish(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def publish(client, params), do: Client.request(:post, "/v1/stream/publish", params, client)

  @doc "List subscriptions"
  @spec list_subscriptions(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list_subscriptions(client), do: Client.request(:get, "/v1/stream/subscriptions", nil, client)
end

  @doc """
  Subscribe to real-time events via SSE on a channel.

  Returns a stream of events that can be consumed with `Enum.each/2` or similar.

  ## Examples

      HookSniff.stream()
      |> HookSniff.Stream.subscribe("channel_id")
      |> Enum.each(fn event -> IO.inspect(event) end)
  """
  def subscribe(%HookSniff{} = hs, channel_id) do
    url = "#{hs.server_url}/v1/stream/channels/#{channel_id}/subscribe"
    headers = [{"authorization", "Bearer #{hs.api_key}"}]

    Stream.resource(
      fn -> HTTPoison.get!(url, headers, stream_to: self(), async: :once) end,
      fn
        %HTTPoison.AsyncResponse{id: id} = resp ->
          receive do
            %HTTPoison.AsyncChunk{chunk: chunk} ->
              {[chunk], resp}
            %HTTPoison.AsyncEnd{} ->
              {:halt, resp}
          after
            30_000 -> {:halt, resp}
          end
      end,
      fn _resp -> :ok end
    )
  end
