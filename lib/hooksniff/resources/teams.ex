defmodule HookSniff.Teams do
  @moduledoc "Team management — list, create, members, invite, roles."

  alias HookSniff.Client

  @doc "List teams"
  @spec list(HookSniff.t()) :: {:ok, map()} | {:error, term()}
  def list(client), do: Client.request(:get, "/v1/teams", nil, client)

  @doc "Create a team"
  @spec create(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def create(client, params), do: Client.request(:post, "/v1/teams", params, client)

  @doc "Get a team by ID"
  @spec get(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, id), do: Client.request(:get, "/v1/teams/#{id}", nil, client)

  @doc "Accept a team invite"
  @spec accept_invite(HookSniff.t(), map()) :: {:ok, map()} | {:error, term()}
  def accept_invite(client, params), do: Client.request(:post, "/v1/teams/accept-invite", params, client)

  @doc "Invite a member"
  @spec invite(HookSniff.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def invite(client, team_id, params), do: Client.request(:post, "/v1/teams/#{team_id}/invite", params, client)

  @doc "List members"
  @spec list_members(HookSniff.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def list_members(client, team_id), do: Client.request(:get, "/v1/teams/#{team_id}/members", nil, client)

  @doc "Remove a member"
  @spec remove_member(HookSniff.t(), String.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def remove_member(client, team_id, user_id), do: Client.request(:delete, "/v1/teams/#{team_id}/members/#{user_id}", nil, client)

  @doc "Change member role"
  @spec change_role(HookSniff.t(), String.t(), String.t(), map()) :: {:ok, map()} | {:error, term()}
  def change_role(client, team_id, user_id, params), do: Client.request(:put, "/v1/teams/#{team_id}/members/#{user_id}/role", params, client)
end
