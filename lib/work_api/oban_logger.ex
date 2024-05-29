defmodule WorkApi.ObanLogger do
  require Logger

  @moduledoc """
  Logging configuration for Oban.
  """

  @type oban_event :: atom()
  @spec handle_event(oban_event :: list(oban_event()), map(), map(), any()) :: any()
  def handle_event(event, measure, meta, _) do
    fmter = &"[Oban] #{&1} on #{&2} #{&3 || "no measurement"}"

    case event do
      [:oban, :job, :start] ->
        Logger.info(fmter.(:start, meta.worker, "started at: #{measure.system_time}"))

      [:oban, :job, :exceptioin] ->
        Logger.warning(fmter.(:exception, meta.worker, nil))

      [:oban, :job, :stop] ->
        Logger.info(fmter.(:stop, meta.worker, "duration: #{measure.duration}"))

      [:oban, :job, event] ->
        Logger.info(fmter.(event, meta.worker, nil))

      event ->
        Logger.error("unknown oban logging event received #{inspect(event)}")
    end
  end
end
