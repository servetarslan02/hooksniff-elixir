defmodule HookSniff.Config do
  @moduledoc """
  Configuration options for the HookSniff client.

  ## Fields

    * `server_url` — Base URL of the HookSniff API
    * `timeout` — Request timeout in milliseconds
    * `debug` — Enable debug logging
    * `headers` — Custom headers to include in every request
    * `num_retries` — Number of retries for 5xx errors

  ## Usage

      config = HookSniff.Config.new(
        server_url: "https://hooksniff-api-1046140057667.europe-west1.run.app",
        timeout: 60_000,
        debug: true,
        headers: %{"x-custom" => "value"}
      )
  """

  @default_server_url "https://hooksniff-api-1046140057667.europe-west1.run.app"

  defstruct [
    server_url: @default_server_url,
    timeout: 30_000,
    debug: false,
    headers: %{},
    num_retries: 3,
  ]

  @type t :: %__MODULE__{
    server_url: String.t(),
    timeout: pos_integer(),
    debug: boolean(),
    headers: map(),
    num_retries: non_neg_integer()
  }

  @doc "Create a new config with default values."
  def new(opts \\ []) do
    struct!(__MODULE__, opts)
  end

  @doc "Get the default server URL."
  def default_server_url, do: @default_server_url
end
