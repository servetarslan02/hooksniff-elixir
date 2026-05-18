defmodule HookSniff.ServiceTokens do
  @moduledoc "Service token management."

  alias HookSniff.Client

  @doc "List tokens"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/api/v1/service-tokens", nil, client)

  @doc "Create a token"
  @spec create(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create(client, params), do: Client.request(:post, "/api/v1/service-tokens", params, client)

  @doc "Delete a token"
  @spec delete(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete(client, id), do: Client.request(:delete, "/api/v1/service-tokens/#{id}", nil, client)

  @doc "Reveal a token"
  @spec reveal(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def reveal(client, id), do: Client.request(:post, "/api/v1/service-tokens/#{id}/reveal", nil, client)
end
