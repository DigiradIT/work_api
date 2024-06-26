defmodule WorkApiWeb.Plugs.Auth do
  @moduledoc """
  Simple plug for dispatching to Plug.BasicAuth 
  at run time.
  """
  def init(opts), do: opts

  def call(conn, _opts) do
    username = Application.fetch_env!(:work_api, :api_user)
    password = Application.fetch_env!(:work_api, :api_password)
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end
end
