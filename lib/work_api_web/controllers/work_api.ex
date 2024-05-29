defmodule WorkApiWeb.WorkApi do
  @moduledoc """
  Controller for API requests that request that tasks be run.
  This controller is responsible for validating the instructions 
  passed from the API caller and creating the Oban jobs that will 
  execute the query.
  """
  use WorkApiWeb, :controller
  require Logger
  alias Ecto.Changeset, as: CS

  plug :fetch_o365_pass when action in [:add_alias]

  def root(conn, _params) do
    resp(conn, 200, Jason.encode!(%{hello: "you made it"}))
  end

  def echo(conn, _params) do
    json(conn, conn.body_params)
  end

  def add_alias(conn, _params) do
    add_alias_command = %{
      group: :string,
      alias: :string,
      password: :string
    }

    username = Application.get_env(:work_api, :m365_username)
    password = conn.assigns[:o365_password]

    cs =
      {%{}, add_alias_command}
      |> CS.cast(conn.body_params, Map.keys(add_alias_command))
      |> CS.validate_required([:group, :alias])

    if cs.valid? do
      cs.changes
      |> Map.put(:password, password)
      |> Map.put(:username, username)
      |> WorkApi.Jobs.AddMailAlias.new()
      |> Oban.insert()

      resp(conn, 200, "ok")
    else
      resp(conn, 400, "invalid body")
    end
  end

  def fetch_o365_pass(conn, _opts) do
    key_name = Application.get_env(:work_api, :m365_secret_name)

    with {:ok, token} <- WorkApi.Token.fetch(:key_vault),
         {:ok, pass} <- WorkApi.Secret.fetch(key_name, token) do
      assign(conn, :o365_password, pass)
    else
      _ ->
        conn
        |> resp(500, Jason.encode!(%{"error" => "cloud credential error"}))
        |> halt()
    end
  end
end
