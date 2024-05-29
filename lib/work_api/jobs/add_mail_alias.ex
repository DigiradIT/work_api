defmodule WorkApi.Jobs.AddMailAlias do
  use Oban.Worker, queue: :commands
  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    IO.inspect("we are here")
    password = args["password"]
    target_group = args["group"]
    alias = args["alias"]
    IO.inspect("#{password}, #{target_group}, #{alias}", label: "our inputs")
    script_path = Application.app_dir(:work_api, "priv/ps_scripts/add_alias.ps1")
    # return_value = System.cmd("pwsh", ["-Command Write-Host \"wow\""])
    return_value = System.cmd("pwsh", [script_path, password, target_group, alias])
    IO.inspect(return_value, label: "return value")
    :ok
  end
end
