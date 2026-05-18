defmodule HookSniff.ResponseMetadata do
  @moduledoc """
  Response metadata from the last API request.

  Access via `client.last_response` after any API call.

  ## Fields

    * `status_code` — HTTP status code
    * `request_id` — x-request-id header
    * `rate_limit_remaining` — x-ratelimit-remaining header
    * `rate_limit_reset` — x-ratelimit-reset header (Unix timestamp)
    * `headers` — All response headers as a map

  ## Usage

      {:ok, endpoints} = HookSniff.Endpoint.list(client)
      meta = client.last_response
      IO.puts(meta.request_id)
  """

  @enforce_keys [:status_code]
  defstruct [:status_code, :request_id, :rate_limit_remaining, :rate_limit_reset, headers: %{}]

  @type t :: %__MODULE__{
    status_code: integer(),
    request_id: String.t() | nil,
    rate_limit_remaining: integer() | nil,
    rate_limit_reset: integer() | nil,
    headers: map()
  }

  @doc """
  Create from Tesla response headers.
  """
  @spec from_tesla(integer(), [{String.t(), String.t()}]) :: t()
  def from_tesla(status_code, headers) when is_list(headers) do
    header_map = Map.new(headers)
    %__MODULE__{
      status_code: status_code,
      request_id: header_map["x-request-id"],
      rate_limit_remaining: parse_int(header_map["x-ratelimit-remaining"]),
      rate_limit_reset: parse_int(header_map["x-ratelimit-reset"]),
      headers: header_map
    }
  end

  defp parse_int(nil), do: nil
  defp parse_int(str) do
    case Integer.parse(str) do
      {n, _} -> n
      :error -> nil
    end
  end
end
