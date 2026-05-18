defmodule HookSniff.CustomDomains do
  @moduledoc "Custom domain management."

  alias HookSniff.Client

  @doc "List domains"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/v1/custom-domains", nil, client)

  @doc "Add a domain"
  @spec add(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def add(client, params), do: Client.request(:post, "/v1/custom-domains", params, client)

  @doc "Delete a domain"
  @spec delete(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete(client, id), do: Client.request(:delete, "/v1/custom-domains/#{id}", nil, client)

  @doc "Verify a domain"
  @spec verify(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def verify(client, id), do: Client.request(:post, "/v1/custom-domains/#{id}/verify", nil, client)
end
