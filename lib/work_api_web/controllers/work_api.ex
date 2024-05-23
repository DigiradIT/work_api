defmodule WorkApiWeb.WorkApi do
  use WorkApiWeb, :controller

  def root(conn, _params) do
    resp(conn, 200, Jason.encode!(%{hello: "you made it"}))
  end

  def echo(conn, _params) do
    json(conn, conn.body_params)
  end
end
