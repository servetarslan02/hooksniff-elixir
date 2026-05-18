defmodule HookSniff.Applications do
  @moduledoc "Application management — CRUD."

  alias HookSniff.Client

  @doc "List applications"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/v1/applications", nil, client)

  @doc "Create an application"
  @spec create(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create(client, params), do: Client.request(:post, "/v1/applications", params, client)

  @doc "Get an application"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, id), do: Client.request(:get, "/v1/applications/#{id}", nil, client)

  @doc "Update an application"
  @spec update(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def update(client, id, params), do: Client.request(:put, "/v1/applications/#{id}", params, client)

  @doc "Delete an application"
  @spec delete(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete(client, id), do: Client.request(:delete, "/v1/applications/#{id}", nil, client)
end
