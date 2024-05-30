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
      alias: :string
    }

    cs =
      {%{}, add_alias_command}
      |> CS.cast(conn.body_params, Map.keys(add_alias_command))
      |> CS.validate_required([:group, :alias])

    if cs.valid? do
      Ecto.Multi.new()
      |> Oban.insert(:add_job, WorkApi.Jobs.AddMailAlias.new(cs.changes))
      |> Oban.insert(
        :remove_job,
        WorkApi.Jobs.RemoveMailAlias.new(cs.changes, schedule_in: 60 * 5)
      )
      |> WorkApi.Repo.transaction()

      resp(conn, 200, "ok")
    else
      resp(conn, 400, "invalid body")
    end
  end
end
