defmodule HookSniff.WebhookEvent do
  @moduledoc """
  Represents a parsed webhook event from HookSniff.

  Contains the event type, payload data, and timestamp from a verified webhook delivery.

  ## Fields

    * `event` — Event type name (e.g., `"endpoint.created"`)
    * `data` — Event payload data as a map
    * `timestamp` — ISO 8601 timestamp string

  ## Usage

      {:ok, %HookSniff.WebhookEvent{} = event} = HookSniff.Webhook.verify(body, headers, secret)
      IO.puts(event.event)      # "endpoint.created"
      IO.inspect(event.data)    # %{"endpointId" => "ep_123", ...}
      IO.puts(event.timestamp)  # "2026-05-19T02:33:00Z"
  """

  @enforce_keys [:event, :data, :timestamp]
  defstruct [:event, :data, :timestamp]

  @type t :: %__MODULE__{
    event: String.t(),
    data: map(),
    timestamp: String.t()
  }

  @doc """
  Create a new WebhookEvent from a parsed JSON map.

  ## Parameters

    * `json` — Parsed JSON map with `"event"`, `"data"`, `"timestamp"` keys

  ## Returns

  A `%WebhookEvent{}` struct.
  """
  @spec parse(map()) :: t()
  def parse(json) when is_map(json) do
    %__MODULE__{
      event: json["event"] || json[:event] || "",
      data: json["data"] || json[:data] || %{},
      timestamp: json["timestamp"] || json[:timestamp] || ""
    }
  end

  @doc """
  Get the event type name (alias for `event` field).
  """
  @spec event_type(t()) :: String.t()
  def event_type(%__MODULE__{event: event}), do: event

  @doc """
  Get a value from the data map by key.
  """
  @spec get(t(), String.t()) :: term() | nil
  def get(%__MODULE__{data: data}, key) when is_map(data) do
    Map.get(data, key)
  end
end
