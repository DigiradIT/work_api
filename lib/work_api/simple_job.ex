defmodule WorkApi.SimpleJob do
  use Oban.Worker, queue: :commands

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    file_name = args["fileName"]
    System.shell("touch #{file_name}")
    :ok
  end
end
