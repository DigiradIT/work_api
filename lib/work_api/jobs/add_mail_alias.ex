defmodule WorkApi.Jobs.AddMailAlias do
  use Oban.Worker, queue: :commands

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    password = args["password"]
    target_group = args["group"]
    alias = args["alias"]
    script_path = Application.app_dir(:work_api, "priv/ps_scripts/add_alias.ps1")
    {_value, 0} = System.cmd("pwsh", [script_path, password, target_group, alias])
    :ok
  end
end
