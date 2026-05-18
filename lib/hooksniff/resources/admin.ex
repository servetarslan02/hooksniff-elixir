defmodule HookSniff.Admin do
  @moduledoc "Admin operations — users, stats, revenue, settings."

  alias HookSniff.Client

  @doc "List users"
  @spec list_users(HookSniff.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def list_users(client, opts \\ []) do
    path = build_query("/v1/admin/users", opts)
    Client.request(:get, path, nil, client)
  end

  @doc "Get user detail"
  @spec get_user(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get_user(client, user_id), do: Client.request(:get, "/v1/admin/users/#{user_id}", nil, client)

  @doc "Change user plan"
  @spec change_plan(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def change_plan(client, user_id, params), do: Client.request(:put, "/v1/admin/users/#{user_id}/plan", params, client)

  @doc "Change user status"
  @spec change_status(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def change_status(client, user_id, params), do: Client.request(:put, "/v1/admin/users/#{user_id}/status", params, client)

  @doc "Impersonate a user"
  @spec impersonate(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def impersonate(client, user_id), do: Client.request(:post, "/v1/admin/users/#{user_id}/impersonate", nil, client)

  @doc "Get system stats"
  @spec get_stats(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def get_stats(client), do: Client.request(:get, "/v1/admin/stats", nil, client)

  @doc "Get revenue"
  @spec get_revenue(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def get_revenue(client), do: Client.request(:get, "/v1/admin/revenue", nil, client)

  @doc "Get churn report"
  @spec get_churn(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def get_churn(client), do: Client.request(:get, "/v1/admin/churn", nil, client)

  @doc "Get platform settings"
  @spec get_settings(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def get_settings(client), do: Client.request(:get, "/v1/admin/settings", nil, client)

  @doc "Update platform settings"
  @spec update_settings(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def update_settings(client, params), do: Client.request(:put, "/v1/admin/settings", params, client)

  defp build_query(path, opts) do
    params = Enum.filter(opts, fn {_k, v} -> v != nil end)
    case params do
      [] -> path
      _ ->
        query = params |> Enum.map(fn {k, v} -> "#{k}=#{URI.encode_www_form(to_string(v))}" end) |> Enum.join("&")
        "#{path}?#{query}"
    end
  end
end
