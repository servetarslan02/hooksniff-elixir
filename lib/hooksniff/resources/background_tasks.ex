defmodule HookSniff.BackgroundTasks do
  @moduledoc "Background task management."

  alias HookSniff.Client

  @doc "List background tasks"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/api/v1/background-tasks", nil, client)

  @doc "Get a task"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, id), do: Client.request(:get, "/api/v1/background-tasks/#{id}", nil, client)

  @doc "Cancel a task"
  @spec cancel(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def cancel(client, id), do: Client.request(:put, "/api/v1/background-tasks/#{id}", nil, client)
end
