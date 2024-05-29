defmodule WorkApi.Jobs.RemoveMailAlias do
  use Oban.Worker, queue: :commands
  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    password = args["password"]
    target_group = args["group"]
    alias = args["alias"]
    username = args["username"]
    script_path = Application.app_dir(:work_api, "priv/ps_scripts/remove_alias.ps1")

    {value, error_code} =
      System.cmd("pwsh", [script_path, username, password, target_group, alias])

    Logger.info(%{"remove alias return value" => value})

    if error_code == 0 do
      :ok
    else
      raise "script error"
    end
  end
end
