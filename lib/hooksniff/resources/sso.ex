defmodule HookSniff.SSO do
  @moduledoc "SSO configuration."

  alias HookSniff.Client

  @doc "Get SSO config"
  @spec get_config(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def get_config(client), do: Client.request(:get, "/api/v1/sso/config", nil, client)

  @doc "Create or update SSO config"
  @spec upsert_config(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def upsert_config(client, params), do: Client.request(:post, "/api/v1/sso/config", params, client)

  @doc "Delete SSO config"
  @spec delete_config(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def delete_config(client), do: Client.request(:delete, "/api/v1/sso/config", nil, client)

  @doc "Test SSO connection"
  @spec test_connection(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def test_connection(client), do: Client.request(:post, "/api/v1/sso/test", nil, client)
end
