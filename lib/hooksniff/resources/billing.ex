defmodule HookSniff.Billing do
  @moduledoc "Billing and subscription management."

  alias HookSniff.Client

  @doc "Get current subscription"
  @spec get_subscription(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def get_subscription(client), do: Client.request(:get, "/v1/billing/subscription", nil, client)

  @doc "Cancel subscription"
  @spec cancel_subscription(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def cancel_subscription(client), do: Client.request(:delete, "/v1/billing/subscription", nil, client)

  @doc "Upgrade plan"
  @spec upgrade(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def upgrade(client, params), do: Client.request(:post, "/v1/billing/upgrade", params, client)

  @doc "Open billing portal"
  @spec open_portal(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def open_portal(client), do: Client.request(:post, "/v1/billing/portal", %{}, client)

  @doc "Get billing usage"
  @spec get_usage(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def get_usage(client), do: Client.request(:get, "/v1/billing/usage", nil, client)

  @doc "Get invoices"
  @spec get_invoices(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def get_invoices(client), do: Client.request(:get, "/v1/billing/invoices", nil, client)
end
