defmodule WorkApi.Secret do
  alias WorkApi.Errors.{UnexpectedContent, UnexpectedResponse}

  @moduledoc """
  Functions for working with secrets stored in 
  Azure key vaults.
  """
  @api_version "7.4"
  @typedoc """
  The secret value returned from an Azure key vault
  """
  @type secret_value :: String.t()

  @spec fetch(secret_name :: String.t(), token :: WorkApi.Token.access_token()) ::
          {:ok, secret_value()} | {:error, Exception.t()}
  def fetch(secret_name, token) do
    url = create_url(secret_name)

    with {:ok, resp} <-
           Req.get(url, auth: {:bearer, token}, params: %{"api-version" => @api_version}),
         {:ok, resp} <- check_status(resp),
         {:ok, secret} <- check_content(resp) do
      {:ok, secret}
    end
  end

  def check_status(%Req.Response{} = resp) do
    if resp.status == 200 do
      {:ok, resp}
    else
      {:error,
       %UnexpectedResponse{expected_code: 200, response_code: resp.status, response: resp}}
    end
  end

  def check_content(%Req.Response{} = resp) do
    if secret = resp.body["value"] do
      {:ok, secret}
    else
      {:error,
       %UnexpectedContent{
         expected: "body with value field holding secret value",
         received: resp.body
       }}
    end
  end

  defp create_url(secret_name) do
    Path.join(Application.fetch_env!(:work_api, :keyvault_url), "secrets/#{secret_name}")
  end
end
