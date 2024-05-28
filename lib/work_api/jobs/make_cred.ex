defmodule WorkApi.Jobs.MakeCred do
  use Oban.Worker, queue: :commands
  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    password = args["password"]
    Logger.info(%{"current dir" => File.cwd!()})
    {_, 0} = System.cmd("pwsh", ["./ps_scripts/make_cred.ps1", password])
    :ok
  end
end
