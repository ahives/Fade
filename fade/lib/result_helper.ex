defmodule Fade.ResultHelper do
  alias Fade.Types.{DebugInfo, Error, Result}

  def get_successful_response(data, url) do
    Result.new(
      data: data,
      has_data: true,
      debug: %DebugInfo{
        url: url,
        response: nil,
        response: data
      }
    )
  end

  def get_faulted_response(status_code, url) do
    Result.new(
      data: nil,
      has_faulted: true,
      debug: %DebugInfo{
        url: url,
        response: nil,
        error: get_error(status_code)
      }
    )
  end

  def get_faulted_response_with_reason(reason, url) do
    Result.new(
      data: nil,
      has_faulted: true,
      debug: %DebugInfo{
        url: url,
        response: nil,
        error: Error.new(reason: reason)
      }
    )
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
end
