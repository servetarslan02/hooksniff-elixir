defmodule HookSniff.ResponseMetadataTest do
  use ExUnit.Case, async: true

  alias HookSniff.ResponseMetadata

  describe "ResponseMetadata" do
    test "creates struct with all fields" do
      meta = %ResponseMetadata{
        status_code: 200,
        request_id: "req_123",
        rate_limit_remaining: 99,
        rate_limit_reset: 1700000000,
        headers: %{"content-type" => "application/json"}
      }

      assert meta.status_code == 200
      assert meta.request_id == "req_123"
      assert meta.rate_limit_remaining == 99
      assert meta.rate_limit_reset == 1700000000
    end

    test "creates struct with nil optional fields" do
      meta = %ResponseMetadata{
        status_code: 200,
        request_id: nil,
        rate_limit_remaining: nil,
        rate_limit_reset: nil,
        headers: %{}
      }

      assert meta.status_code == 200
      assert meta.request_id == nil
      assert meta.rate_limit_remaining == nil
    end

    test "headers is a map" do
      meta = %ResponseMetadata{
        status_code: 200,
        request_id: "req_1",
        headers: %{"x-request-id" => "req_1", "x-ratelimit-remaining" => "50"}
      }

      assert meta.headers["x-request-id"] == "req_1"
      assert meta.headers["x-ratelimit-remaining"] == "50"
    end

    test "rate limit parsing" do
      headers = %{"x-ratelimit-remaining" => "42"}
      remaining = headers["x-ratelimit-remaining"]
      assert remaining == "42"
    end

    test "request id extraction" do
      headers = %{"x-request-id" => "req_abc123"}
      request_id = headers["x-request-id"]
      assert request_id == "req_abc123"
    end

    test "status codes" do
      for code <- [200, 201, 204, 400, 401, 403, 404, 429, 500, 502, 503] do
        meta = %ResponseMetadata{status_code: code, headers: %{}}
        assert meta.status_code == code
      end
    end
  end
end
