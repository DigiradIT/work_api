defmodule WorkApi.Errors.UnexpectedContent do
  @moduledoc """
  Represents unexpected content received from rest api.
  """
  defexception [:expected, :received]

  def message(e) do
    "Unexpected content, expected: #{e.expected} but received #{e.response}"
  end
end
