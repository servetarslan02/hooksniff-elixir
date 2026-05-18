defmodule HookSniff.Health do
  @moduledoc "API health check."

  alias HookSniff.Client

  @doc "Check API health"
  @spec check(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def check(client), do: Client.request(:get, "/v1/health", nil, client)
end
