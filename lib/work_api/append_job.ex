defmodule WorkApi.AppendJob do
  use Oban.Worker, queue: :commands

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    file_name = args["fileName"]
    file_path = args["path"]
    content = args["content"]
    System.cmd("pwsh", ["./ps_scripts/write_to_file.ps1", content, file_name, file_path])
    :ok
  end
end
