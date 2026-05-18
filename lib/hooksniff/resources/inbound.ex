defmodule HookSniff.Inbound do
  @moduledoc "Inbound webhook configuration."

  alias HookSniff.Client

  @doc "List inbound configs"
  @spec list_configs(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list_configs(client), do: Client.request(:get, "/api/v1/inbound/configs", nil, client)

  @doc "Create a config"
  @spec create_config(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create_config(client, params), do: Client.request(:post, "/api/v1/inbound/configs", params, client)

  @doc "Update a config"
  @spec update_config(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def update_config(client, id, params), do: Client.request(:put, "/api/v1/inbound/configs/#{id}", params, client)

  @doc "Delete a config"
  @spec delete_config(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete_config(client, id), do: Client.request(:delete, "/api/v1/inbound/configs/#{id}", nil, client)

  @doc "Handle inbound webhook"
  @spec handle(HookSniff.t(), String.t(), map(), keyword()) :: {:ok, map()} | {:error, term()}
  def handle(client, provider, body, headers \\ []) do
    # Headers are passed as extra headers in the request
    Client.request(:post, "/api/v1/inbound/#{provider}", body, client)
  end
end
