defmodule HookSniff.AuditLog do
  @moduledoc "Audit log entries."

  alias HookSniff.Client

  @doc "List audit log entries"
  @spec list(HookSniff.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def list(client, opts \\ []) do
    path = build_query("/v1/audit-log", opts)
    Client.request(:get, path, nil, client)
  end

  @doc "Get an entry"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, id), do: Client.request(:get, "/v1/audit-log/#{id}", nil, client)

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
