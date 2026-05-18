defmodule HookSniff.WebhookEvent do
  @moduledoc """
  Represents a parsed webhook event from HookSniff.

  Contains the event type, payload data, and timestamp from a verified webhook delivery.

  ## Fields

    * `event` — Event type name (e.g., `"endpoint.created"`)
    * `data` — Event payload data as a map (or typed struct after parsing)
    * `timestamp` — ISO 8601 timestamp string

  ## Usage

      {:ok, %HookSniff.WebhookEvent{} = event} = HookSniff.Webhook.verify(body, headers, secret)
      IO.puts(event.event)      # "endpoint.created"
      IO.inspect(event.data)    # %{"endpointId" => "ep_123", ...}

  ## Typed Data Parsing

      typed = HookSniff.WebhookEvent.parse_endpoint_created_data(event)
      IO.puts(typed.endpoint_id)
  """

  @enforce_keys [:event, :data, :timestamp]
  defstruct [:event, :data, :timestamp]

  @type t :: %__MODULE__{
    event: String.t(),
    data: map(),
    timestamp: String.t()
  }

  # ─── Typed Data Structs ──────────────────────────────────────────

  defmodule EndpointCreatedData do
    @moduledoc "Typed data for endpoint.created events"
    defstruct [:app_id, :endpoint_id, :app_uid]
    @type t :: %__MODULE__{app_id: String.t(), endpoint_id: String.t(), app_uid: String.t() | nil}
  end

  defmodule EndpointUpdatedData do
    @moduledoc "Typed data for endpoint.updated events"
    defstruct [:app_id, :endpoint_id, :app_uid]
    @type t :: %__MODULE__{app_id: String.t(), endpoint_id: String.t(), app_uid: String.t() | nil}
  end

  defmodule EndpointDeletedData do
    @moduledoc "Typed data for endpoint.deleted events"
    defstruct [:app_id, :endpoint_id, :app_uid]
    @type t :: %__MODULE__{app_id: String.t(), endpoint_id: String.t(), app_uid: String.t() | nil}
  end

  defmodule EndpointEnabledData do
    @moduledoc "Typed data for endpoint.enabled events"
    defstruct [:app_id, :endpoint_id, :app_uid]
    @type t :: %__MODULE__{app_id: String.t(), endpoint_id: String.t(), app_uid: String.t() | nil}
  end

  defmodule EndpointDisabledData do
    @moduledoc "Typed data for endpoint.disabled events"
    defstruct [:app_id, :endpoint_id, :app_uid, :fail_since, :trigger]
    @type t :: %__MODULE__{app_id: String.t(), endpoint_id: String.t(), app_uid: String.t() | nil, fail_since: String.t() | nil, trigger: String.t() | nil}
  end

  defmodule LastAttemptInfo do
    @moduledoc "Info about the last delivery attempt"
    defstruct [:id, :timestamp, :response_status_code]
    @type t :: %__MODULE__{id: String.t(), timestamp: String.t(), response_status_code: integer()}
  end

  defmodule AttemptInfo do
    @moduledoc "Info about a delivery attempt"
    defstruct [:id, :timestamp, :response_status_code]
    @type t :: %__MODULE__{id: String.t(), timestamp: String.t(), response_status_code: integer()}
  end

  defmodule MessageAttemptExhaustedData do
    @moduledoc "Typed data for message.attempt.exhausted events"
    defstruct [:app_id, :msg_id, :last_attempt, :app_uid]
    @type t :: %__MODULE__{app_id: String.t(), msg_id: String.t(), last_attempt: LastAttemptInfo.t(), app_uid: String.t() | nil}
  end

  defmodule MessageAttemptFailingData do
    @moduledoc "Typed data for message.attempt.failing events"
    defstruct [:app_id, :msg_id, :attempt, :app_uid]
    @type t :: %__MODULE__{app_id: String.t(), msg_id: String.t(), attempt: AttemptInfo.t(), app_uid: String.t() | nil}
  end

  defmodule MessageAttemptRecoveredData do
    @moduledoc "Typed data for message.attempt.recovered events"
    defstruct [:app_id, :msg_id, :attempt, :app_uid]
    @type t :: %__MODULE__{app_id: String.t(), msg_id: String.t(), attempt: AttemptInfo.t(), app_uid: String.t() | nil}
  end

  # ─── Core Functions ──────────────────────────────────────────────

  @doc """
  Create a new WebhookEvent from a parsed JSON map.
  """
  @spec parse(map()) :: t()
  def parse(json) when is_map(json) do
    event = json["event"] || json[:event] || ""
    raw_data = json["data"] || json[:data] || %{}
    timestamp = json["timestamp"] || json[:timestamp] || ""

    parsed_data = parse_event_data(event, raw_data)

    %__MODULE__{
      event: event,
      data: parsed_data,
      timestamp: timestamp
    }
  end

  @doc "Get the event type name (alias for `event` field)."
  @spec event_type(t()) :: String.t()
  def event_type(%__MODULE__{event: event}), do: event

  @doc "Get a value from the data map by key."
  @spec get(t(), String.t()) :: term() | nil
  def get(%__MODULE__{data: data}, key) when is_map(data) do
    Map.get(data, key)
  end
  def get(_, _), do: nil

  # ─── Typed Data Parsing ──────────────────────────────────────────

  @doc "Parse event data as EndpointCreatedData."
  @spec parse_endpoint_created_data(t()) :: EndpointCreatedData.t()
  def parse_endpoint_created_data(%__MODULE__{data: d}) do
    %EndpointCreatedData{
      app_id: get_raw(d, "appId", "app_id"),
      endpoint_id: get_raw(d, "endpointId", "endpoint_id"),
      app_uid: get_raw(d, "appUid", "app_uid")
    }
  end

  @doc "Parse event data as EndpointUpdatedData."
  @spec parse_endpoint_updated_data(t()) :: EndpointUpdatedData.t()
  def parse_endpoint_updated_data(%__MODULE__{data: d}) do
    %EndpointUpdatedData{
      app_id: get_raw(d, "appId", "app_id"),
      endpoint_id: get_raw(d, "endpointId", "endpoint_id"),
      app_uid: get_raw(d, "appUid", "app_uid")
    }
  end

  @doc "Parse event data as EndpointDeletedData."
  @spec parse_endpoint_deleted_data(t()) :: EndpointDeletedData.t()
  def parse_endpoint_deleted_data(%__MODULE__{data: d}) do
    %EndpointDeletedData{
      app_id: get_raw(d, "appId", "app_id"),
      endpoint_id: get_raw(d, "endpointId", "endpoint_id"),
      app_uid: get_raw(d, "appUid", "app_uid")
    }
  end

  @doc "Parse event data as EndpointEnabledData."
  @spec parse_endpoint_enabled_data(t()) :: EndpointEnabledData.t()
  def parse_endpoint_enabled_data(%__MODULE__{data: d}) do
    %EndpointEnabledData{
      app_id: get_raw(d, "appId", "app_id"),
      endpoint_id: get_raw(d, "endpointId", "endpoint_id"),
      app_uid: get_raw(d, "appUid", "app_uid")
    }
  end

  @doc "Parse event data as EndpointDisabledData."
  @spec parse_endpoint_disabled_data(t()) :: EndpointDisabledData.t()
  def parse_endpoint_disabled_data(%__MODULE__{data: d}) do
    %EndpointDisabledData{
      app_id: get_raw(d, "appId", "app_id"),
      endpoint_id: get_raw(d, "endpointId", "endpoint_id"),
      app_uid: get_raw(d, "appUid", "app_uid"),
      fail_since: get_raw(d, "failSince", "fail_since"),
      trigger: Map.get(d, "trigger")
    }
  end

  @doc "Parse event data as MessageAttemptExhaustedData."
  @spec parse_message_attempt_exhausted_data(t()) :: MessageAttemptExhaustedData.t()
  def parse_message_attempt_exhausted_data(%__MODULE__{data: d}) do
    last_raw = Map.get(d, "lastAttempt") || Map.get(d, "last_attempt") || %{}
    %MessageAttemptExhaustedData{
      app_id: get_raw(d, "appId", "app_id"),
      msg_id: get_raw(d, "msgId", "msg_id"),
      last_attempt: parse_last_attempt(last_raw),
      app_uid: get_raw(d, "appUid", "app_uid")
    }
  end

  @doc "Parse event data as MessageAttemptFailingData."
  @spec parse_message_attempt_failing_data(t()) :: MessageAttemptFailingData.t()
  def parse_message_attempt_failing_data(%__MODULE__{data: d}) do
    att_raw = Map.get(d, "attempt") || %{}
    %MessageAttemptFailingData{
      app_id: get_raw(d, "appId", "app_id"),
      msg_id: get_raw(d, "msgId", "msg_id"),
      attempt: parse_attempt(att_raw),
      app_uid: get_raw(d, "appUid", "app_uid")
    }
  end

  @doc "Parse event data as MessageAttemptRecoveredData."
  @spec parse_message_attempt_recovered_data(t()) :: MessageAttemptRecoveredData.t()
  def parse_message_attempt_recovered_data(%__MODULE__{data: d}) do
    att_raw = Map.get(d, "attempt") || %{}
    %MessageAttemptRecoveredData{
      app_id: get_raw(d, "appId", "app_id"),
      msg_id: get_raw(d, "msgId", "msg_id"),
      attempt: parse_attempt(att_raw),
      app_uid: get_raw(d, "appUid", "app_uid")
    }
  end

  # ─── Internal Helpers ────────────────────────────────────────────

  defp parse_event_data("endpoint.created", d), do: parse_endpoint_created_data(%__MODULE__{event: "endpoint.created", data: d, timestamp: ""})
  defp parse_event_data("endpoint.updated", d), do: parse_endpoint_updated_data(%__MODULE__{event: "endpoint.updated", data: d, timestamp: ""})
  defp parse_event_data("endpoint.deleted", d), do: parse_endpoint_deleted_data(%__MODULE__{event: "endpoint.deleted", data: d, timestamp: ""})
  defp parse_event_data("endpoint.enabled", d), do: parse_endpoint_enabled_data(%__MODULE__{event: "endpoint.enabled", data: d, timestamp: ""})
  defp parse_event_data("endpoint.disabled", d), do: parse_endpoint_disabled_data(%__MODULE__{event: "endpoint.disabled", data: d, timestamp: ""})
  defp parse_event_data("message.attempt.exhausted", d), do: parse_message_attempt_exhausted_data(%__MODULE__{event: "message.attempt.exhausted", data: d, timestamp: ""})
  defp parse_event_data("message.attempt.failing", d), do: parse_message_attempt_failing_data(%__MODULE__{event: "message.attempt.failing", data: d, timestamp: ""})
  defp parse_event_data("message.atattempt.failing", d), do: parse_message_attempt_failing_data(%__MODULE__{event: "message.atattempt.failing", data: d, timestamp: ""})
  defp parse_event_data("message.attempt.recovered", d), do: parse_message_attempt_recovered_data(%__MODULE__{event: "message.attempt.recovered", data: d, timestamp: ""})
  defp parse_event_data("message.atattempt.recovered", d), do: parse_message_attempt_recovered_data(%__MODULE__{event: "message.atattempt.recovered", data: d, timestamp: ""})
  defp parse_event_data(_, d), do: d

  defp parse_last_attempt(raw) do
    %LastAttemptInfo{
      id: Map.get(raw, "id") || "",
      timestamp: Map.get(raw, "timestamp") || "",
      response_status_code: Map.get(raw, "responseStatusCode") || Map.get(raw, "response_status_code") || 0
    }
  end

  defp parse_attempt(raw) do
    %AttemptInfo{
      id: Map.get(raw, "id") || "",
      timestamp: Map.get(raw, "timestamp") || "",
      response_status_code: Map.get(raw, "responseStatusCode") || Map.get(raw, "response_status_code") || 0
    }
  end

  defp get_raw(map, key1, key2) do
    Map.get(map, key1) || Map.get(map, key2)
  end
end
