defmodule HookSniff.Schemas do
  @moduledoc "Schema registry — register, validate."

  alias HookSniff.Client

  @doc "List schemas"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/v1/schemas", nil, client)

  @doc "Register a schema"
  @spec register(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def register(client, params), do: Client.request(:post, "/v1/schemas", params, client)

  @doc "Get a schema"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, id), do: Client.request(:get, "/v1/schemas/#{id}", nil, client)

  @doc "Validate an event"
  @spec validate(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def validate(client, id, params), do: Client.request(:post, "/v1/schemas/#{id}/validate", params, client)
end
