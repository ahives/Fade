defmodule Fade.Broker do
  alias Fade.ResultHelper
  alias Fade.Types.{DebugInfo, Error, Result}

  @username "guest"
  @password "guest"
  @base_url "http://localhost:15672/"

  def get_all_request(url) do
    headers = get_credentials(@username, @password) |> get_headers()
    url = @base_url <> url

    case HTTPoison.get(url, headers) do
      {:ok, response} ->
        case response.status_code do
          200 -> ResultHelper.get_successful_response(response.body, url)
          _ -> ResultHelper.get_faulted_response(response.status_code, url)
        end

      {:error, reason} ->
        ResultHelper.get_faulted_response_with_reason(reason, url)
    end
  end

  def get_headers(credentials) do
    [Authorization: "Basic #{credentials}", Accept: "application/json"]
  end

  def get_credentials(username, password) do
    "#{username}:#{password}" |> Base.encode64()
  end
end
