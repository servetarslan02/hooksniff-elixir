defmodule HookSniff.EventTypes do
  @moduledoc "Manage event types — list, create, update, delete, import from OpenAPI."

  alias HookSniff.Client

  @doc "List event types (paginated). Accepts `:limit`, `:offset`, `:include_archived` opts."
  @spec list(HookSniff.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def list(client, opts \\ []) do
    path = build_query("/v1/event-types", opts)
    Client.request(:get, path, nil, client)
  end

  @doc "Create a new event type"
  @spec create(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create(client, params), do: Client.request(:post, "/v1/event-types", params, client)

  @doc "Get event type by name"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, name), do: Client.request(:get, "/v1/event-types/#{name}", nil, client)

  @doc "Update an event type"
  @spec update(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def update(client, name, params), do: Client.request(:put, "/v1/event-types/#{name}", params, client)

  @doc "Patch an event type"
  @spec patch(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def patch(client, name, params), do: Client.request(:patch, "/v1/event-types/#{name}", params, client)

  @doc "Delete an event type"
  @spec delete(HookSniff.t(), String.t()) :: {:ok, :ok} | {:error, term()}
  def delete(client, name) do
    case Client.request(:delete, "/v1/event-types/#{name}", nil, client) do
      {:ok, _} -> {:ok, :ok}
      error -> error
    end
  end

  @doc """
  Import event types from an OpenAPI spec.

  ## Parameters

    * `client` — The HookSniff client
    * `params` — Map with:
      * `spec` (optional) — A pre-parsed JSON spec (map)
      * `specRaw` (optional) — A string, parsed by the server as YAML or JSON
      * `dryRun` (optional) — If `true`, return types without modifying
      * `replaceAll` (optional) — If `true`, archive types not in spec

  ## Returns

    * `{:ok, %{"data" => %{"modified" => [...], "toModify" => [...]}}}` on success
    * `{:error, reason}` on failure
  """
  @spec import_openapi(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def import_openapi(client, params) do
    Client.request(:post, "/v1/event-types/import-openapi", params, client)
  end

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
