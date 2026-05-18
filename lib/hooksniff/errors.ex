defmodule HookSniff.ApiError do
  @moduledoc """
  Base error for all HookSniff API errors.
  """
  defexception [:status, :body, :headers]

  @impl true
  def message(%{status: status, body: body}) do
    "HookSniff API Error #{status}: #{inspect(body)}"
  end
end

defmodule HookSniff.BadRequestError do
  @moduledoc "400 Bad Request — The request was malformed or missing required fields"
  defexception [:detail, :headers]
  @impl true, do: def(message(%{detail: d}), do: d || "Bad request")
end

defmodule HookSniff.UnauthorizedError do
  @moduledoc "401 Unauthorized — Invalid or missing authentication"
  defexception [:message, :headers]
  @impl true, do: def(message(%{message: m}), do: m || "Unauthorized")
end

defmodule HookSniff.ForbiddenError do
  @moduledoc "403 Forbidden — Insufficient permissions"
  defexception [:message, :headers]
  @impl true, do: def(message(%{message: m}), do: m || "Forbidden")
end

defmodule HookSniff.NotFoundError do
  @moduledoc "404 Not Found — Resource does not exist"
  defexception [:message, :headers]
  @impl true, do: def(message(%{message: m}), do: m || "Not found")
end

defmodule HookSniff.ConflictError do
  @moduledoc "409 Conflict — Resource already exists or conflict"
  defexception [:message, :headers]
  @impl true, do: def(message(%{message: m}), do: m || "Conflict")
end

defmodule HookSniff.UnprocessableEntityError do
  @moduledoc "422 Unprocessable Entity — Validation error"
  defexception [:validation_errors, :message, :headers]
  @impl true, do: def(message(%{message: m}), do: m || "Unprocessable entity")
end

defmodule HookSniff.RateLimitError do
  @moduledoc "429 Too Many Requests — Rate limit exceeded"
  defexception [:retry_after, :headers]

  @impl true
  def message(%{retry_after: ra}) do
    case ra do
      nil -> "Rate limit exceeded"
      s -> "Rate limit exceeded (retry after #{s}s)"
    end
  end
end

defmodule HookSniff.InternalServerError do
  @moduledoc "500 Internal Server Error"
  defexception [:message, :headers]
  @impl true, do: def(message(%{message: m}), do: m || "Internal server error")
end

defmodule HookSniff.BadGatewayError do
  @moduledoc "502 Bad Gateway"
  defexception [:message, :headers]
  @impl true, do: def(message(%{message: m}), do: m || "Bad gateway")
end

defmodule HookSniff.ServiceUnavailableError do
  @moduledoc "503 Service Unavailable"
  defexception [:message, :headers]
  @impl true, do: def(message(%{message: m}), do: m || "Service unavailable")
end

defmodule HookSniff.GatewayTimeoutError do
  @moduledoc "504 Gateway Timeout"
  defexception [:message, :headers]
  @impl true, do: def(message(%{message: m}), do: m || "Gateway timeout")
end

defmodule HookSniff.ValidationErrorItem do
  @moduledoc "Validation error item from 422 responses"
  defstruct [:loc, :msg, :type]
end

defmodule HookSniff.ErrorFactory do
  @moduledoc "Factory to create the appropriate error from a status code"

  def create(status, body, headers \\ %{}) do
    case status do
      400 -> %HookSniff.BadRequestError{detail: body, headers: headers}
      401 -> %HookSniff.UnauthorizedError{message: body, headers: headers}
      403 -> %HookSniff.ForbiddenError{message: body, headers: headers}
      404 -> %HookSniff.NotFoundError{message: body, headers: headers}
      409 -> %HookSniff.ConflictError{message: body, headers: headers}
      422 -> %HookSniff.UnprocessableEntityError{message: body, headers: headers}
      429 ->
        retry_after = Map.get(headers, "retry-after") |> parse_integer()
        %HookSniff.RateLimitError{retry_after: retry_after, headers: headers}
      500 -> %HookSniff.InternalServerError{message: body, headers: headers}
      502 -> %HookSniff.BadGatewayError{message: body, headers: headers}
      503 -> %HookSniff.ServiceUnavailableError{message: body, headers: headers}
      504 -> %HookSniff.GatewayTimeoutError{message: body, headers: headers}
      _ -> %HookSniff.ApiError{status: status, body: body, headers: headers}
    end
  end

  defp parse_integer(nil), do: nil
  defp parse_integer(str) do
    case Integer.parse(str) do
      {n, _} -> n
      :error -> nil
    end
  end
end
