defmodule WorkApi.Token do
  alias WorkApi.Errors.{UnexpectedResponse, UnexpectedContent}

  @moduledoc """
  Used for requesting and managing machine identity from Azure.
  """
  @url "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/"

  @typedoc """
  A token that can be used to authenticate against MSFT APIs.
  """
  @type access_token :: String.t()

  @spec fetch() :: {:ok, access_token()} | {:error, Exception.t()}
  def fetch() do
    with {:ok, resp} <- Req.get(@url, headers: %{"metadata" => true}),
         {:ok, resp} <- check_status(resp),
         {:ok, token} <- check_content(resp) do
      {:ok, token}
    end
  end

  @spec check_status(Req.Response.t()) :: {:ok, Req.Response.t()} | {:error, Exception.t()}
  defp check_status(%Req.Response{} = resp) do
    if resp.status == 200 do
      {:ok, resp}
    else
      {:error,
       %UnexpectedResponse{expected_code: 200, response_code: resp.status, response: resp}}
    end
  end

  @spec check_content(Req.Resposne.t()) :: {:ok, access_token()} | {:error, Exception.t()}
  defp check_content(%Req.Response{} = resp) do
    if token = resp.body["access_token"] do
      {:ok, token}
    else
      {:error, %UnexpectedContent{expected: "body with access token field", received: resp.body}}
    end
  end
end
