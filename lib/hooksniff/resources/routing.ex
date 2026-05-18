defmodule HookSniff.Routing do
  @moduledoc "Endpoint routing configuration."

  alias HookSniff.Client

  @doc "Get routing for endpoint"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, endpoint_id), do: Client.request(:get, "/api/v1/routing/#{endpoint_id}/routing", nil, client)

  @doc "Update routing"
  @spec update(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def update(client, endpoint_id, params), do: Client.request(:put, "/api/v1/routing/#{endpoint_id}/routing", params, client)

  @doc "Get routing health"
  @spec get_health(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get_health(client, endpoint_id), do: Client.request(:get, "/api/v1/routing/#{endpoint_id}/health", nil, client)
end
