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

    key_name = Application.get_env(:work_api, :m365_secret_name)

    with {:ok, token} <- WorkApi.Token.fetch(:key_vault),
         {:ok, secret} <- WorkApi.Secret.fetch(key_name, token) do
      cs =
        {%{}, add_alias_command}
        |> CS.cast(conn.body_params, Map.keys(add_alias_command))
        |> CS.validate_required([:group, :alias])

      if cs.valid? do
        user = Application.get_env(:work_api, :m365_user)

        cs.changes
        |> Map.put(:password, secret)
        |> Map.put(:username, user)
        |> WorkApi.Jobs.AddMailAlias.new()
        |> Oban.insert()

        resp(conn, 200, "ok")
      else
        resp(conn, 400, "invalid body")
      end
    else
      {:error, e} ->
        Logger.error(e)
        resp(conn, 500, Jason.encode!(%{"error" => "error running task"}))
    end
  end
end
