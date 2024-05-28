defmodule WorkApi.Token do
  @moduledoc """
  Used for requesting and managing machine identity from Azure. 
  """
  @url "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/"

  @spec fetch() :: Map | Exception.t()
  def fetch() do
    case Req.get(@url, headers: %{"metadata" => true}) do
      {:ok, resp} ->
        resp

      {:error, e} ->
        e
    end
  end
end
