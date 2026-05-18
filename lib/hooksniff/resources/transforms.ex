defmodule HookSniff.Transforms do
  @moduledoc "Payload transform rules."

  alias HookSniff.Client

  @doc "List transforms"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/v1/transforms", nil, client)

  @doc "Create a transform"
  @spec create(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create(client, params), do: Client.request(:post, "/v1/transforms", params, client)

  @doc "Update a transform"
  @spec update(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def update(client, id, params), do: Client.request(:put, "/v1/transforms/#{id}", params, client)

  @doc "Delete a transform"
  @spec delete(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete(client, id), do: Client.request(:delete, "/v1/transforms/#{id}", nil, client)

  @doc "Test a transform"
  @spec test_transform(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def test_transform(client, params), do: Client.request(:post, "/v1/transforms/test", params, client)
end
