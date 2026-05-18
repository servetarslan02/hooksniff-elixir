defmodule HookSniff.Auth do
  @moduledoc "Authentication — register, login, logout, 2FA, password, GDPR."

  alias HookSniff.Client

  @doc "Register a new user"
  @spec register(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def register(client, params), do: Client.request(:post, "/api/v1/auth/register", params, client)

  @doc "Log in"
  @spec login(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def login(client, params), do: Client.request(:post, "/api/v1/auth/login", params, client)

  @doc "Log out"
  @spec logout(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def logout(client), do: Client.request(:post, "/api/v1/auth/logout", nil, client)

  @doc "Get current user"
  @spec me(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def me(client), do: Client.request(:get, "/api/v1/auth/me", nil, client)

  @doc "Update profile"
  @spec update_profile(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def update_profile(client, params), do: Client.request(:put, "/api/v1/auth/profile", params, client)

  @doc "Change password"
  @spec change_password(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def change_password(client, params), do: Client.request(:put, "/api/v1/auth/password", params, client)

  @doc "Forgot password"
  @spec forgot_password(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def forgot_password(client, params), do: Client.request(:post, "/api/v1/auth/forgot-password", params, client)

  @doc "Reset password"
  @spec reset_password(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def reset_password(client, params), do: Client.request(:post, "/api/v1/auth/reset-password", params, client)

  @doc "Verify email"
  @spec verify_email(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def verify_email(client, params), do: Client.request(:post, "/api/v1/auth/verify-email", params, client)

  @doc "Resend verification email"
  @spec resend_verification(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def resend_verification(client, params), do: Client.request(:post, "/api/v1/auth/resend-verification", params, client)

  @doc "Enable two-factor authentication"
  @spec enable_2fa(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def enable_2fa(client), do: Client.request(:post, "/api/v1/auth/2fa/enable", nil, client)

  @doc "Confirm 2FA setup"
  @spec confirm_2fa(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def confirm_2fa(client, params), do: Client.request(:post, "/api/v1/auth/2fa/confirm", params, client)

  @doc "Disable 2FA"
  @spec disable_2fa(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def disable_2fa(client, params), do: Client.request(:post, "/api/v1/auth/2fa/disable", params, client)

  @doc "Get 2FA status"
  @spec get_2fa_status(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def get_2fa_status(client), do: Client.request(:get, "/api/v1/auth/2fa/status", nil, client)

  @doc "Export user data (GDPR)"
  @spec export_data(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def export_data(client), do: Client.request(:get, "/api/v1/auth/export", nil, client)

  @doc "Delete user account"
  @spec delete_account(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def delete_account(client, params), do: Client.request(:delete, "/api/v1/auth/account", params, client)
end
