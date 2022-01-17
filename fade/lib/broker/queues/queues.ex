defmodule Fade.Broker.Queues do
  use TypedStruct
  require Logger

  alias Fade.Sanitizer
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Broker.Queue.Types.{QueueInfo}
  alias Fade.Broker
  alias Fade.Broker.ServerResponse
  alias Fade.Types.Result
  alias Fade.Broker.Core.DataMappings

  @doc """
  Returns all queues on the current RabbitMQ node.
  """
  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/queues")
    |> map_result()
  end

  defp map_result(server_response = %ServerResponse{}) do
    case Jason.decode(server_response.data) do
      {:ok, decoded_object} ->
        decoded_object
        |> map_queues
        |> Result.get_successful_response(server_response.data, server_response.url)

      {:error, _} ->
        Result.get_faulted_response_with_reason(
          "Error decoding the returned object.",
          server_response.url
        )
    end
  end

  defp map_queues(queues) do
    queues
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn queue ->
      QueueInfo.new(
        message_details: DataMappings.map_rate(queue["message_details"]),
        total_messages: queue["total_messages"],
        unacknowledged_message_details:
          DataMappings.map_rate(queue["unacknowledged_message_details"])
        # destination_type: queue["destination_type"],
        # routing_key: queue["routing_key"],
        # arguments: queue["arguments"],
        # properties_key: queue["properties_key"]
      )
    end)
  end
end
