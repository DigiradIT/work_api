defmodule WorkApi.Errors.UnexpectedResponse do
  @moduledoc """
  Represents an unexpected response from
  a Rest API
  """
  defexception [:response, :expected_code, :response_code]

  def message(e) do
    "Expected #{e.response_code} but received #{e.response_code}"
  end
end
