defmodule HookSniff.Notifications do
  @moduledoc "Notification management."

  alias HookSniff.Client

  @doc "List notifications"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/api/v1/notifications", nil, client)

  @doc "Get unread count"
  @spec unread_count(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def unread_count(client), do: Client.request(:get, "/api/v1/notifications/unread-count", nil, client)

  @doc "Mark all as read"
  @spec mark_all_read(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def mark_all_read(client), do: Client.request(:put, "/api/v1/notifications/read-all", nil, client)

  @doc "Mark one as read"
  @spec mark_read(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def mark_read(client, id), do: Client.request(:put, "/api/v1/notifications/#{id}/read", nil, client)

  @doc "Delete a notification"
  @spec delete(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete(client, id), do: Client.request(:delete, "/api/v1/notifications/#{id}", nil, client)
end
