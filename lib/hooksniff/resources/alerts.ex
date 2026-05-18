defmodule HookSniff.Alerts do
  @moduledoc "Alert rules and notifications."

  alias HookSniff.Client

  @doc "List alerts"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/v1/alerts", nil, client)

  @doc "Create an alert"
  @spec create(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create(client, params), do: Client.request(:post, "/v1/alerts", params, client)

  @doc "Get an alert by ID"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, id), do: Client.request(:get, "/v1/alerts/#{id}", nil, client)

  @doc "Update an alert"
  @spec update(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def update(client, id, params), do: Client.request(:put, "/v1/alerts/#{id}", params, client)

  @doc "Delete an alert"
  @spec delete(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete(client, id), do: Client.request(:delete, "/v1/alerts/#{id}", nil, client)

  @doc "Test an alert"
  @spec test_alert(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def test_alert(client, id), do: Client.request(:post, "/v1/alerts/#{id}/test", %{}, client)
end
