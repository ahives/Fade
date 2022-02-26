defmodule Fade.Types do
  use TypedStruct
  # require Protocol

  typedstruct module: Error do
    field(:reason, String.t())
    field(:timestamp, DateTime.t())

    def new(fields) do
      struct!(__MODULE__, Keyword.merge([timestamp: DateTime.utc_now()], fields))
    end
  end

  typedstruct module: DebugInfo do
    field(:url, String.t())
    field(:request, String.t())
    field(:response, String.t())
    field(:error, Error.t(), default: nil)

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: Result do
    field(:data, Map.t())
    field(:has_data, boolean(), default: false)
    field(:debug, DebugInfo.t())
    field(:has_faulted, boolean(), default: false)
    field(:timestamp, DateTime.t())

    def new(fields) do
      struct!(__MODULE__, Keyword.merge([timestamp: DateTime.utc_now()], fields))
    end

    def get_successful_response(data, response_data, url) do
      Result.new(
        data: data,
        has_data: true,
        debug:
          DebugInfo.new(
            url: url,
            response: nil,
            response: response_data
          )
      )
    end

    def get_faulted_response(status_code, url) do
      Result.new(
        data: nil,
        has_faulted: true,
        debug:
          DebugInfo.new(
            url: url,
            response: nil,
            error: get_error(status_code)
          )
      )
    end

    def get_faulted_response_with_reason(reason, url) do
      Result.new(
        data: nil,
        has_faulted: true,
        debug:
          DebugInfo.new(
            url: url,
            response: nil,
            error: Error.new(reason: reason)
          )
      )
    end

    defp get_error(status_code) do
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

        _ ->
          nil
      end
    end
  end
end
