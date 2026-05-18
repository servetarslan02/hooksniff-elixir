# HookSniff Elixir SDK

<p align="center">
  <a href="https://hex.pm/packages/hooksniff"><img src="https://img.shields.io/hexpm/v/hooksniff" alt="Hex Version"></a>
  <a href="https://hex.pm/packages/hooksniff"><img src="https://img.shields.io/hexpm/dt/hooksniff" alt="Hex Downloads"></a>
  <a href="https://github.com/servetarslan02/hooksniff-elixir/blob/main/LICENSE"><img src="https://img.shields.io/hexpm/l/hooksniff" alt="License"></a>
</p>

Official Elixir SDK for the [HookSniff](https://hooksniff.com) webhook delivery platform.

## Installation

```elixir
# mix.exs
defp deps do
  [
    {:hooksniff, "~> 1.2"}
  ]
end
```

## Quick Start

```elixir
# Create a client
client = HookSniff.new(api_key: "sk_live_xxx")

# List endpoints
{:ok, %{status: 200, body: endpoints}} = HookSniff.Endpoints.list(client)

# Send a webhook
{:ok, %{status: 200, body: msg}} = HookSniff.Webhooks.send_webhook(client, %{
  event: "user.created",
  payload: %{email: "user@example.com"}
})

# Verify incoming webhook
{:ok, payload} = HookSniff.Webhook.verify(raw_body, headers, "whsec_xxx")
```

## Resources

| Resource | Module | Description |
|----------|--------|-------------|
| Admin | `HookSniff.Admin` | Users, stats, revenue, settings |
| Alerts | `HookSniff.Alerts` | Alert rules and test |
| Analytics | `HookSniff.Analytics` | Delivery trend, success rate, latency |
| API Keys | `HookSniff.ApiKeys` | List, create, delete, rotate |
| Applications | `HookSniff.Applications` | Application CRUD |
| Auth | `HookSniff.Auth` | Register, login, 2FA, password, GDPR |
| Audit Log | `HookSniff.AuditLog` | Audit trail |
| Background Tasks | `HookSniff.BackgroundTasks` | List, get, cancel |
| Billing | `HookSniff.Billing` | Subscription, usage, invoices |
| Connectors | `HookSniff.Connectors` | Connector management |
| Custom Domains | `HookSniff.CustomDomains` | Add, verify, delete |
| Devices | `HookSniff.Devices` | Push device registration |
| Endpoints | `HookSniff.Endpoints` | CRUD, headers, secret rotation |
| Environments | `HookSniff.Environments` | Env vars management |
| Health | `HookSniff.Health` | Health check |
| Inbound | `HookSniff.Inbound` | Inbound webhook configs |
| Integrations | `HookSniff.Integrations` | Integration CRUD |
| Message Attempts | `HookSniff.MessageAttempts` | Delivery attempts |
| Message Poller | `HookSniff.MessagePoller` | Poll, seek, commit |
| Notifications | `HookSniff.Notifications` | List, mark read |
| Operational Webhooks | `HookSniff.OperationalWebhooks` | Ops webhook endpoints |
| Portal | `HookSniff.Portal` | Customer portal config |
| Rate Limits | `HookSniff.RateLimits` | Per-endpoint rate limiting |
| Routing | `HookSniff.Routing` | Endpoint routing rules |
| Schemas | `HookSniff.Schemas` | Schema registry, validation |
| Search | `HookSniff.Search` | Delivery search |
| Service Tokens | `HookSniff.ServiceTokens` | Token management |
| SSO | `HookSniff.SSO` | SSO configuration |
| Stream | `HookSniff.Stream` | Real-time streaming |
| Teams | `HookSniff.Teams` | Team members, roles |
| Templates | `HookSniff.Templates` | Webhook templates |
| Transforms | `HookSniff.Transforms` | Payload transforms |
| Webhooks | `HookSniff.Webhooks` | Send, list, replay |

## Webhook Verification

```elixir
alias HookSniff.Webhook

headers = %{
  "hooksniff-id" => "msg_123",
  "hooksniff-timestamp" => "1678900000",
  "hooksniff-signature" => "v1,abc123..."
}

case Webhook.verify(raw_body, headers, "whsec_xxx") do
  {:ok, payload} ->
    # Process the webhook
    IO.inspect(payload)

  {:error, %Webhook.VerificationError{message: reason}} ->
    # Reject the webhook
    IO.puts("Invalid: #{reason}")
end
```

## Configuration

```elixir
client = HookSniff.new(
  api_key: "sk_live_xxx",
  base_url: "https://your-instance.hooksniff.com",  # optional
  timeout: 30_000,                                    # optional
  num_retries: 2                                      # optional
)
```

## Error Handling

```elixir
case HookSniff.Endpoints.get(client, "ep_123") do
  {:ok, %{status: 200, body: endpoint}} ->
    IO.inspect(endpoint)

  {:ok, %{status: 404, body: _}} ->
    IO.puts("Not found")

  {:ok, %{status: status, body: body}} ->
    IO.puts("Error #{status}: #{inspect(body)}")

  {:error, reason} ->
    IO.puts("Request failed: #{inspect(reason)}")
end
```

## Links

- [Hex.pm](https://hex.pm/packages/hooksniff)
- [Documentation](https://hexdocs.pm/hooksniff)
- [GitHub](https://github.com/servetarslan02/hooksniff-elixir)
- [HookSniff](https://hooksniff.com)

## License

MIT
