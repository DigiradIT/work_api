defmodule WorkApi.M365 do
  @moduledoc """
  Functions for working with M365.
  """
  alias WorkApi.{Token, Secret}

  @type m365_password :: String.t()

  @spec fetch_m365_pass() :: {:ok, m365_password()} | {:error, Exception.t()}
  def fetch_m365_pass() do
    key_name = Application.get_env(:work_api, :m365_secret_name)

    with {:ok, token} <- Token.fetch(:key_vault),
         {:ok, pass} <- Secret.fetch(key_name, token) do
      {:ok, pass}
    end
  end
end
