defmodule Fade.Types do
  use TypedStruct

  typedstruct module: BindingInfo do
    field(:source, String.t())
    field(:virtual_host, String.t())
    field(:destination, String.t())
    field(:destination_type, String.t())
    field(:routing_key, String.t())
    field(:arguments, Map.t(), default: %{})
    field(:properties_key, String.t())
  end

  typedstruct module: FadeConfig do
    field(:base_url, String.t(), default: "http://localhost:15672/")
    field(:timeout, integer())
    field(:username, String.t(), default: "guest")
    field(:password, String.t(), default: "guest")
  end

  typedstruct module: BrokerConfig do
    field(:base_url, String.t())
    field(:headers, list(), default: [])
  end

  typedstruct module: Error do
    field(:reason, String.t())
    field(:timestamp, DateTime.t())

    def new(fields) do
      struct!(Error, Keyword.merge([timestamp: DateTime.utc_now()], fields))
    end
  end

  typedstruct module: DebugInfo do
    field(:url, String.t())
    field(:request, String.t())
    field(:response, String.t())
    field(:error, Error.t(), default: nil)
  end

  typedstruct module: Result do
    field(:data, Map.t())
    field(:has_data, boolean(), default: false)
    field(:debug, DebugInfo.t())
    field(:has_faulted, boolean(), default: false)
    field(:timestamp, DateTime.t())

    def new(fields) do
      struct!(Result, Keyword.merge([timestamp: DateTime.utc_now()], fields))
    end

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
      end
    end
  end
end
