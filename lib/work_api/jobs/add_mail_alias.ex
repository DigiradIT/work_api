defmodule WorkApi.Jobs.AddMailAlias do
  use Oban.Worker, queue: :commands
  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    password = args["password"]
    target_group = args["group"]
    alias = args["alias"]
    script_path = Application.app_dir(:work_api, "priv/ps_scripts/add_alias.ps1")
    {return_value, 0} = System.cmd("pwsh", [script_path, password, target_group, alias])
    Logger.info(%{"return value" => return_value})
    :ok
  end
end
