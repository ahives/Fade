defmodule Fade.Broker do
  alias Fade.Types.{DebugInfo, Error, Result}
  @username "guest"
  @password "guest"
  @base_url "http://localhost:15672/"

  def get_all_request(url) do
    headers = get_credentials(@username, @password) |> get_headers()

    url = @base_url <> url

    case HTTPoison.get(url, headers) do
      {:ok, response} ->
        errors = [get_error(response.status_code) | []]

        Result.new(
          data: response.body,
          has_data: true,
          debug: %DebugInfo{
            url: url,
            response: response.body,
            errors: errors
          }
        )

      {:error, _reason} ->
        Result.new()
    end
  end

  def get_error(status_code) do
    case status_code do
      400 ->
        Error.new(
          reason: "RabbitMQ server did not recognize the request due to malformed syntax."
        )

      403 ->
        Error.new(reason: "RabbitMQ server rejected the request.")

      406 ->
        Error.new(
          reason: "RabbitMQ server rejected the request because the method is not acceptable."
        )

      405 ->
        Error.new(
          reason: "RabbitMQ server rejected the request because the method is not allowed."
        )

      500 ->
        Error.new(reason: "Internal error happened on RabbitMQ server.")

      408 ->
        Error.new(
          reason: "No response from the RabbitMQ server within the specified window of time."
        )

      503 ->
        Error.new(reason: "RabbitMQ server temporarily not able to handle request.")

      401 ->
        Error.new(reason: "Unauthorized access to RabbitMQ server resource.")
        # 403 -> Error.new(reason: "")
    end
  end

  def get_headers(credentials) do
    [Authorization: "Basic #{credentials}", Accept: "application/json"]
  end

  def get_credentials(username, password) do
    "#{username}:#{password}" |> Base.encode64()
  end
end
