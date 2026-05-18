defmodule HookSniff.Devices do
  @moduledoc "Push device management."

  alias HookSniff.Client

  @doc "List devices"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/v1/devices", nil, client)

  @doc "Register a device"
  @spec register(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def register(client, params), do: Client.request(:post, "/v1/devices", params, client)

  @doc "Delete a device"
  @spec delete(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete(client, id), do: Client.request(:delete, "/v1/devices/#{id}", nil, client)
end
