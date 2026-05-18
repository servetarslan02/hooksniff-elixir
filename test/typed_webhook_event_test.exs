defmodule HookSniff.TypedWebhookEventTest do
  use ExUnit.Case, async: true

  alias HookSniff.WebhookEvent

  describe "typed event parsing" do
    test "endpoint.created" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.created",
        "data" => %{"appId" => "a1", "endpointId" => "e1", "appUid" => "u1"},
        "timestamp" => "2026-05-19"
      })

      assert event.event == "endpoint.created"
      assert event.timestamp == "2026-05-19"

      data = WebhookEvent.parse_endpoint_created_data(event)
      assert data.app_id == "a1"
      assert data.endpoint_id == "e1"
      assert data.app_uid == "u1"
    end

    test "endpoint.disabled with extras" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.disabled",
        "data" => %{"appId" => "a1", "endpointId" => "e1", "failSince" => "2026-01", "trigger" => "repeated-failure"},
        "timestamp" => ""
      })

      data = WebhookEvent.parse_endpoint_disabled_data(event)
      assert data.fail_since == "2026-01"
      assert data.trigger == "repeated-failure"
    end

    test "message.attempt.exhausted" do
      event = WebhookEvent.parse(%{
        "event" => "message.attempt.exhausted",
        "data" => %{
          "appId" => "a1",
          "msgId" => "m1",
          "lastAttempt" => %{"id" => "att", "timestamp" => "t", "responseStatusCode" => 500}
        },
        "timestamp" => ""
      })

      data = WebhookEvent.parse_message_attempt_exhausted_data(event)
      assert data.app_id == "a1"
      assert data.msg_id == "m1"
      assert data.last_attempt.id == "att"
      assert data.last_attempt.response_status_code == 500
    end

    test "message.attempt.failing" do
      event = WebhookEvent.parse(%{
        "event" => "message.atattempt.failing",
        "data" => %{
          "appId" => "a1",
          "msgId" => "m1",
          "attempt" => %{"id" => "att", "timestamp" => "t", "responseStatusCode" => 429}
        },
        "timestamp" => ""
      })

      data = WebhookEvent.parse_message_attempt_failing_data(event)
      assert data.attempt.response_status_code == 429
    end

    test "message.attempt.recovered" do
      event = WebhookEvent.parse(%{
        "event" => "message.attempt.recovered",
        "data" => %{
          "appId" => "a1",
          "msgId" => "m1",
          "attempt" => %{"id" => "att", "timestamp" => "t", "responseStatusCode" => 200}
        },
        "timestamp" => ""
      })

      data = WebhookEvent.parse_message_attempt_recovered_data(event)
      assert data.attempt.response_status_code == 200
    end

    test "unknown event falls back to raw map" do
      event = WebhookEvent.parse(%{
        "event" => "custom.unknown",
        "data" => %{"x" => 1},
        "timestamp" => ""
      })

      assert is_map(event.data)
      assert event.data["x"] == 1
    end
  end

  describe "backward compatibility" do
    test "get/2 works with typed data" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.created",
        "data" => %{"appId" => "a1", "endpointId" => "e1"},
        "timestamp" => "t"
      })

      # get/2 returns nil for typed structs (they don't have string keys)
      assert WebhookEvent.get(event, "appId") == nil
    end

    test "event_type/1 returns event name" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.created",
        "data" => %{},
        "timestamp" => ""
      })

      assert WebhookEvent.event_type(event) == "endpoint.created"
    end
  end

  describe "snake_case fields" do
    test "parses snake_case data fields" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.created",
        "data" => %{"app_id" => "a1", "endpoint_id" => "e1", "app_uid" => "u1"},
        "timestamp" => ""
      })

      data = WebhookEvent.parse_endpoint_created_data(event)
      assert data.app_id == "a1"
      assert data.endpoint_id == "e1"
      assert data.app_uid == "u1"
    end
  end

  describe "all endpoint event types" do
    test "parses all 5 endpoint events" do
      events = [
        "endpoint.created",
        "endpoint.updated",
        "endpoint.deleted",
        "endpoint.enabled",
        "endpoint.disabled"
      ]

      for event_type <- events do
        event = WebhookEvent.parse(%{
          "event" => event_type,
          "data" => %{"appId" => "a1", "endpointId" => "e1"},
          "timestamp" => ""
        })
        assert event.event == event_type
      end
    end
  end

  describe "edge cases" do
    test "empty data" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.created",
        "data" => %{},
        "timestamp" => ""
      })
      data = WebhookEvent.parse_endpoint_created_data(event)
      assert data.app_id == ""
    end

    test "missing data key" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.created",
        "timestamp" => ""
      })
      data = WebhookEvent.parse_endpoint_created_data(event)
      assert data.app_id == ""
    end

    test "unicode data" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.created",
        "data" => %{"appId" => "ünïcödé", "endpointId" => "日本語"},
        "timestamp" => ""
      })
      data = WebhookEvent.parse_endpoint_created_data(event)
      assert data.app_id == "ünïcödé"
      assert data.endpoint_id == "日本語"
    end

    test "extra fields ignored" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.created",
        "data" => %{"appId" => "a1", "endpointId" => "e1", "extra" => "ignored"},
        "timestamp" => ""
      })
      data = WebhookEvent.parse_endpoint_created_data(event)
      assert data.app_id == "a1"
    end

    test "nil data" do
      event = WebhookEvent.parse(%{
        "event" => "test",
        "data" => nil,
        "timestamp" => ""
      })
      assert event.data == nil
    end

    test "large data" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.created",
        "data" => %{"appId" => String.duplicate("a", 10000), "endpointId" => String.duplicate("e", 10000)},
        "timestamp" => ""
      })
      data = WebhookEvent.parse_endpoint_created_data(event)
      assert String.length(data.app_id) == 10000
    end

    test "special characters" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.created",
        "data" => %{"appId" => "a@b.c", "endpointId" => "e#1"},
        "timestamp" => ""
      })
      data = WebhookEvent.parse_endpoint_created_data(event)
      assert data.app_id == "a@b.c"
    end

    test "trigger none" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.disabled",
        "data" => %{"appId" => "a", "endpointId" => "e", "trigger" => "none"},
        "timestamp" => ""
      })
      data = WebhookEvent.parse_endpoint_disabled_data(event)
      assert data.trigger == "none"
    end

    test "trigger first-failure" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.disabled",
        "data" => %{"appId" => "a", "endpointId" => "e", "trigger" => "first-failure"},
        "timestamp" => ""
      })
      data = WebhookEvent.parse_endpoint_disabled_data(event)
      assert data.trigger == "first-failure"
    end

    test "fail_since" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.disabled",
        "data" => %{"appId" => "a", "endpointId" => "e", "failSince" => "2026-01"},
        "timestamp" => ""
      })
      data = WebhookEvent.parse_endpoint_disabled_data(event)
      assert data.fail_since == "2026-01"
    end

    test "all endpoint types" do
      for type <- ["endpoint.created", "endpoint.updated", "endpoint.deleted", "endpoint.enabled", "endpoint.disabled"] do
        event = WebhookEvent.parse(%{"event" => type, "data" => %{"appId" => "a"}, "timestamp" => ""})
        assert event.event == type
      end
    end

    test "get returns nil for typed structs" do
      event = WebhookEvent.parse(%{
        "event" => "endpoint.created",
        "data" => %{"appId" => "a1"},
        "timestamp" => "t"
      })
      assert WebhookEvent.get(event, "appId") == nil
    end

    test "event_type returns event name" do
      event = WebhookEvent.parse(%{"event" => "test", "data" => %{}, "timestamp" => ""})
      assert WebhookEvent.event_type(event) == "test"
    end
  end
end
