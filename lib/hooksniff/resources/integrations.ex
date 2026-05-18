defmodule HookSniff.Integrations do
  @moduledoc "Integration management."

  alias HookSniff.Client

  @doc "List integrations"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/api/v1/integrations", nil, client)

  @doc "Get an integration"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, id), do: Client.request(:get, "/api/v1/integrations/#{id}", nil, client)

  @doc "Create an integration"
  @spec create(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create(client, params), do: Client.request(:post, "/api/v1/integrations", params, client)

  @doc "Update an integration"
  @spec update(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def update(client, id, params), do: Client.request(:put, "/api/v1/integrations/#{id}", params, client)

  @doc "Delete an integration"
  @spec delete(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete(client, id), do: Client.request(:delete, "/api/v1/integrations/#{id}", nil, client)

  @doc "Test an integration"
  @spec test_integration(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def test_integration(client, id), do: Client.request(:post, "/api/v1/integrations/#{id}/test", nil, client)
end
