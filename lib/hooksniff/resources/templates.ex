defmodule HookSniff.Templates do
  @moduledoc "Webhook templates."

  alias HookSniff.Client

  @doc "List templates"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/v1/templates", nil, client)

  @doc "Get a template"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, id), do: Client.request(:get, "/v1/templates/#{id}", nil, client)

  @doc "Apply a template"
  @spec apply(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def apply(client, id, params \\ %{}), do: Client.request(:post, "/v1/templates/#{id}/apply", params, client)
end
