defmodule HookSniff.Stream do
  @moduledoc "Real-time streaming — channels, publish, subscriptions."

  alias HookSniff.Client

  @doc "List channels"
  @spec list_channels(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list_channels(client), do: Client.request(:get, "/api/v1/stream/channels", nil, client)

  @doc "Get a channel"
  @spec get_channel(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get_channel(client, id), do: Client.request(:get, "/api/v1/stream/channels/#{id}", nil, client)

  @doc "Create a channel"
  @spec create_channel(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create_channel(client, params), do: Client.request(:post, "/api/v1/stream/channels", params, client)

  @doc "Delete a channel"
  @spec delete_channel(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete_channel(client, id), do: Client.request(:delete, "/api/v1/stream/channels/#{id}", nil, client)

  @doc "Publish a message"
  @spec publish(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def publish(client, params), do: Client.request(:post, "/api/v1/stream/publish", params, client)

  @doc "List subscriptions"
  @spec list_subscriptions(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list_subscriptions(client), do: Client.request(:get, "/api/v1/stream/subscriptions", nil, client)
end
