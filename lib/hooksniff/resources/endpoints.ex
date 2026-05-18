defmodule HookSniff.Endpoints do
  @moduledoc "Manage webhook endpoints — create, list, update, delete, rotate secrets."

  alias HookSniff.Client

  @doc "List endpoints (paginated). Accepts `:limit` and `:offset` opts."
  @spec list(HookSniff.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def list(client, opts \\ []) do
    path = build_query("/api/v1/endpoints", opts)
    Client.request(:get, path, nil, client)
  end

  @doc "Create a new endpoint"
  @spec create(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create(client, params), do: Client.request(:post, "/api/v1/endpoints", params, client)

  @doc "Get endpoint by ID"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, id), do: Client.request(:get, "/api/v1/endpoints/#{id}", nil, client)

  @doc "Update an endpoint"
  @spec update(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def update(client, id, params), do: Client.request(:put, "/api/v1/endpoints/#{id}", params, client)

  @doc "Delete an endpoint"
  @spec delete(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete(client, id), do: Client.request(:delete, "/api/v1/endpoints/#{id}", nil, client)

  @doc "Rotate the signing secret for an endpoint"
  @spec rotate_secret(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def rotate_secret(client, id), do: Client.request(:post, "/api/v1/endpoints/#{id}/secret/rotate", %{}, client)

  @doc "Get endpoint headers"
  @spec get_headers(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get_headers(client, id), do: Client.request(:get, "/api/v1/endpoints/#{id}/headers", nil, client)

  @doc "Update endpoint headers"
  @spec update_headers(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def update_headers(client, id, params), do: Client.request(:put, "/api/v1/endpoints/#{id}/headers", params, client)

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
