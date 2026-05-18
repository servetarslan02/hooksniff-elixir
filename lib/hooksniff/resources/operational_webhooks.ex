defmodule HookSniff.OperationalWebhooks do
  @moduledoc "Operational webhook endpoint management."

  alias HookSniff.Client

  @doc "List endpoints"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/api/v1/operational-webhooks", nil, client)

  @doc "Create an endpoint"
  @spec create(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create(client, params), do: Client.request(:post, "/api/v1/operational-webhooks", params, client)

  @doc "Get an endpoint"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, id), do: Client.request(:get, "/api/v1/operational-webhooks/#{id}", nil, client)

  @doc "Update an endpoint"
  @spec update(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def update(client, id, params), do: Client.request(:put, "/api/v1/operational-webhooks/#{id}", params, client)

  @doc "Delete an endpoint"
  @spec delete(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete(client, id), do: Client.request(:delete, "/api/v1/operational-webhooks/#{id}", nil, client)

  @doc "List deliveries"
  @spec list_deliveries(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def list_deliveries(client, id), do: Client.request(:get, "/api/v1/operational-webhooks/#{id}/deliveries", nil, client)
end
