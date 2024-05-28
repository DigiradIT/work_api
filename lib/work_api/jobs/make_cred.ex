defmodule WorkApi.Jobs.MakeCred do
  use Oban.Worker, queue: :commands
  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    password = args["password"]
    Logger.info(%{"current dir" => File.cwd!()})
    script_path = Application.app_dir(:work_api, "priv/ps_scripts/make_cred.ps1")
    {_, 0} = System.cmd("pwsh", [script_path, password])
    :ok
  end
end
