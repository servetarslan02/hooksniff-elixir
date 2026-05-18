defmodule HookSniff.MessageAttempts do
  @moduledoc "Delivery attempt tracking."

  alias HookSniff.Client

  @doc "List attempts by endpoint"
  @spec list_by_endpoint(HookSniff.t(), String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def list_by_endpoint(client, endpoint_id, opts \\ []) do
    path = build_query("/v1/webhooks/attempts/endpoint/#{endpoint_id}", opts)
    Client.request(:get, path, nil, client)
  end

  @doc "List attempts by message"
  @spec list_by_msg(HookSniff.t(), String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def list_by_msg(client, msg_id, opts \\ []) do
    path = build_query("/v1/webhooks/#{msg_id}/attempts", opts)
    Client.request(:get, path, nil, client)
  end

  @doc "Get an attempt"
  @spec get(HookSniff.t(), String.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, msg_id, attempt_id), do: Client.request(:get, "/v1/webhooks/#{msg_id}/attempts/#{attempt_id}", nil, client)

  @doc "Resend to endpoint"
  @spec resend(HookSniff.t(), String.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def resend(client, msg_id, endpoint_id), do: Client.request(:post, "/v1/webhooks/#{msg_id}/endpoint/#{endpoint_id}/resend", nil, client)

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
