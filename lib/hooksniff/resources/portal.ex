defmodule HookSniff.Portal do
  @moduledoc "Customer portal configuration."

  alias HookSniff.Client

  @doc "Get portal config"
  @spec get_config(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def get_config(client), do: Client.request(:get, "/api/v1/portal/config", nil, client)

  @doc "Update portal config"
  @spec update_config(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def update_config(client, params), do: Client.request(:put, "/api/v1/portal/config", params, client)

  @doc "Get portal profile"
  @spec get_profile(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def get_profile(client), do: Client.request(:get, "/api/v1/portal/me", nil, client)

  @doc "Get embed code"
  @spec get_embed_code(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def get_embed_code(client), do: Client.request(:get, "/api/v1/portal/embed-code", nil, client)
end
