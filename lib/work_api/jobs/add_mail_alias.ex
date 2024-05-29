defmodule WorkApi.Jobs.AddMailAlias do
  @moduledoc """
  Task for adding an alias to an exiting M365 unified group.
  This will **not** work for security or exchange groups.
  """
  use Oban.Worker, queue: :commands

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    password = args["password"]
    target_group = args["group"]
    alias = args["alias"]
    username = args["username"]
    script_path = Application.app_dir(:work_api, "priv/ps_scripts/add_alias.ps1")
    {_value, 0} = System.cmd("pwsh", [username, script_path, password, target_group, alias])
    :ok
  end
end
