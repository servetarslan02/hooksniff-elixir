defmodule HookSniff.RateLimits do
  @moduledoc "Rate limiting per endpoint."

  alias HookSniff.Client

  @doc "List rate limits"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/v1/rate-limits", nil, client)

  @doc "Get rate limit for endpoint"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, endpoint_id), do: Client.request(:get, "/v1/rate-limits/#{endpoint_id}", nil, client)

  @doc "Set rate limit"
  @spec set(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def set(client, endpoint_id, params), do: Client.request(:post, "/v1/rate-limits/#{endpoint_id}", params, client)

  @doc "Delete rate limit"
  @spec delete(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete(client, endpoint_id), do: Client.request(:delete, "/v1/rate-limits/#{endpoint_id}", nil, client)
end
