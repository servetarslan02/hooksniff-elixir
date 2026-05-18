defmodule HookSniff.Environments do
  @moduledoc "Environment and variable management."

  alias HookSniff.Client

  @doc "List environments"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/v1/environments", nil, client)

  @doc "Create an environment"
  @spec create(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create(client, params), do: Client.request(:post, "/v1/environments", params, client)

  @doc "Get an environment"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, id), do: Client.request(:get, "/v1/environments/#{id}", nil, client)

  @doc "Update an environment"
  @spec update(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def update(client, id, params), do: Client.request(:put, "/v1/environments/#{id}", params, client)

  @doc "Delete an environment"
  @spec delete(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete(client, id), do: Client.request(:delete, "/v1/environments/#{id}", nil, client)

  @doc "List variables"
  @spec list_variables(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def list_variables(client, env_id), do: Client.request(:get, "/v1/environments/#{env_id}/variables", nil, client)

  @doc "Create a variable"
  @spec create_variable(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def create_variable(client, env_id, params), do: Client.request(:post, "/v1/environments/#{env_id}/variables", params, client)

  @doc "Bulk upsert variables"
  @spec bulk_upsert(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def bulk_upsert(client, env_id, params), do: Client.request(:post, "/v1/environments/#{env_id}/variables/bulk", params, client)
end
