defmodule WorkApi.SimpleJob do
  use Oban.Worker, queue: :commands

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    file_name = args["fileName"]
    file_path = args["path"]
    System.shell("touch #{Path.join(file_path, file_name)}")
    :ok
  end
end
