defmodule HookSniff.Connectors do
  @moduledoc "Connector management."

  alias HookSniff.Client

  @doc "List connectors"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/v1/connectors", nil, client)

  @doc "Get a connector"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, id), do: Client.request(:get, "/v1/connectors/#{id}", nil, client)

  @doc "List connector configs"
  @spec list_configs(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list_configs(client), do: Client.request(:get, "/v1/connectors/configs", nil, client)

  @doc "Create a config"
  @spec create_config(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create_config(client, params), do: Client.request(:post, "/v1/connectors/configs", params, client)

  @doc "Get a config"
  @spec get_config(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get_config(client, id), do: Client.request(:get, "/v1/connectors/configs/#{id}", nil, client)

  @doc "Update a config"
  @spec update_config(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def update_config(client, id, params), do: Client.request(:put, "/v1/connectors/configs/#{id}", params, client)

  @doc "Delete a config"
  @spec delete_config(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete_config(client, id), do: Client.request(:delete, "/v1/connectors/configs/#{id}", nil, client)
end
