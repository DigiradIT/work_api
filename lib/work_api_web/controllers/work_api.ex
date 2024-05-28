defmodule WorkApiWeb.WorkApi do
  use WorkApiWeb, :controller
  require Logger
  alias Ecto.Changeset, as: CS

  def root(conn, _params) do
    Logger.warning(%{"token" => WorkApi.Token.fetch()})
    resp(conn, 200, Jason.encode!(%{hello: "you made it"}))
  end

  def echo(conn, _params) do
    json(conn, conn.body_params)
  end

  def touch(conn, _params) do
    touch_command = %{
      fileName: :string,
      path: :string
    }

    inbond_command = Map.merge(%{"path" => "./test_output"}, conn.body_params)

    cs =
      {%{}, touch_command}
      |> CS.cast(inbond_command, Map.keys(touch_command))
      |> CS.validate_required(:fileName)
      |> CS.validate_length(:fileName, min: 1, max: 25)

    if cs.valid? do
      cs.changes
      |> WorkApi.SimpleJob.new()
      |> Oban.insert()

      resp(conn, 200, "ok")
    else
      resp(conn, 400, "invalid body")
    end
  end

  def append(conn, _params) do
    append_command = %{
      fileName: :string,
      path: :string,
      content: :string
    }

    params = Map.merge(%{"path" => "./test_output"}, conn.body_params)

    cs =
      {%{}, append_command}
      |> CS.cast(params, Map.keys(append_command))
      |> CS.validate_required(:fileName)
      |> CS.validate_required(:content)
      |> CS.validate_length(:fileName, min: 1, max: 25)
      |> CS.validate_length(:content, min: 1)

    if cs.valid? do
      cs.changes
      |> WorkApi.AppendJob.new()
      |> Oban.insert()

      resp(conn, 200, "ok")
    else
      resp(conn, 400, "invalid body")
    end
  end
end
