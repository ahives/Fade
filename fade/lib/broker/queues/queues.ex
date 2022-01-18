defmodule Fade.Broker.Queues do
  use TypedStruct
  require Logger

  alias Fade.Sanitizer
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Broker.Queue.Types.QueueInfo
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
          DataMappings.map_rate(queue["unacknowledged_message_details"]),
        unacknowledged_messages: queue["unacknowledged_messages"],
        ready_message_details: DataMappings.map_rate(queue["ready_message_details"]),
        ready_messages: queue["ready_messages"],
        reduction_details: DataMappings.map_rate(queue["reduction_details"]),
        total_reduction: queue["total_reduction"],
        arguments: queue["arguments"],
        exclusive: queue["exclusive"],
        auto_delete: queue["auto_delete"],
        durable: queue["durable"],
        virtual_host: queue["virtual_host"],
        name: queue["name"],
        node: queue["node"],
        message_bytes_paged_out: queue["message_bytes_paged_out"],
        total_messages_paged_out: queue["total_messages_paged_out"],
        backing_queue_status:
          DataMappings.map_backing_queue_status(queue["backing_queue_status"]),
        head_message_timestamp: queue["head_message_timestamp"],
        message_bytes_persisted: queue["message_bytes_persisted"],
        total_bytes_of_messages_delivered_but_unacknowledged:
          queue["total_bytes_of_messages_delivered_but_unacknowledged"],
        total_bytes_of_messages_ready_for_delivery:
          queue["total_bytes_of_messages_ready_for_delivery"],
        total_bytes_of_all_messages: queue["total_bytes_of_all_messages"],
        messages_persisted: queue["messages_persisted"],
        unacknowledged_messages_in_ram: queue["unacknowledged_messages_in_ram"],
        messages_ready_for_delivery_in_ram: queue["messages_ready_for_delivery_in_ram"],
        messages_in_ram: queue["messages_in_ram"],
        gc: DataMappings.map_garbage_collection(queue["gc"]),
        state: String.to_atom(queue["state"]),
        recoverable_slaves: queue["recoverable_slaves"],
        consumers: queue["consumers"],
        exclusive_consumer_tag: queue["exclusive_consumer_tag"],
        policy: queue["policy"],
        consumer_utilization: queue["consumer_utilization"],
        idle_since: queue["idle_since"],
        memory: queue["memory"],
        message_stats: DataMappings.map_queue_message_stats(queue["message_stats"])
      )
    end)
  end
end
