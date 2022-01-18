defmodule Fade.Broker.Queues do
  use TypedStruct
  require Logger

  alias Fade.Config.Types.BrokerConfig
  alias Fade.Broker
  alias Fade.Broker.Core.DataMappings

  alias Fade.Broker.Queue.Types.{
    BackingQueueStatus,
    GarbageCollectionDetails,
    QueueInfo,
    QueueMessageStats
  }

  @doc """
  Returns all queues on the current RabbitMQ node.
  """
  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/queues")
    |> DataMappings.map_result(&map_queues/1)
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
        backing_queue_status: map_backing_queue_status(queue["backing_queue_status"]),
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
        gc: map_garbage_collection(queue["gc"]),
        state: String.to_atom(queue["state"]),
        recoverable_slaves: queue["recoverable_slaves"],
        consumers: queue["consumers"],
        exclusive_consumer_tag: queue["exclusive_consumer_tag"],
        policy: queue["policy"],
        consumer_utilization: queue["consumer_utilization"],
        idle_since: queue["idle_since"],
        memory: queue["memory"],
        message_stats: map_queue_message_stats(queue["message_stats"])
      )
    end)
  end

  defp map_backing_queue_status(data) do
    BackingQueueStatus.new(
      mode: String.to_atom(data["mode"]),
      q1: data["q1"],
      q2: data["q2"],
      q3: data["q3"],
      q4: data["q4"],
      delta: data["delta"],
      length: data["length"],
      target_total_messages_in_ram: data["target_total_messages_in_ram"],
      next_sequence_id: data["next_sequence_id"],
      avg_ingress_rate: data["avg_ingress_rate"],
      avg_egress_rate: data["avg_egress_rate"],
      avg_acknowledgement_ingress_rate: data["avg_acknowledgement_ingress_rate"],
      avg_acknowledgement_egress_rate: data["avg_acknowledgement_egress_rate"]
    )
  end

  defp map_garbage_collection(data) do
    GarbageCollectionDetails.new(
      minor_garbage_collection: data["minor_garbage_collection"],
      full_sweep_after: data["full_sweep_after"],
      minimum_heap_size: data["minimum_heap_size"],
      minimum_binary_virtual_heap_size: data["minimum_binary_virtual_heap_size"],
      maximum_heap_size: data["maximum_heap_size"]
    )
  end

  defp map_queue_message_stats(data) do
    QueueMessageStats.new(
      total_messages_published: data["total_messages_published"],
      messages_published_details: data["messages_published_details"],
      total_message_gets: data["total_message_gets"],
      message_get_details: data["message_get_details"],
      total_message_gets_without_ack: data["total_message_gets_without_ack"],
      message_gets_without_ack_details:
        DataMappings.map_rate(data["message_gets_without_ack_details"]),
      total_messages_delivered: data["total_messages_delivered"],
      message_delivery_details: DataMappings.map_rate(data["message_delivery_details"]),
      total_messages_delivered_without_ack: data["total_messages_delivered_without_ack"],
      messages_delivered_without_ack_details:
        DataMappings.map_rate(data["messages_delivered_without_ack_details"]),
      total_message_delivery_gets: data["total_message_delivery_gets"],
      message_delivery_get_details: DataMappings.map_rate(data["message_delivery_get_details"]),
      total_messages_redelivered: data["total_messages_redelivered"],
      messages_redelivered_details: DataMappings.map_rate(data["messages_redelivered_details"]),
      total_messages_acknowledged: data["total_messages_acknowledged"],
      messages_acknowledged_details: DataMappings.map_rate(data["messages_acknowledged_details"])
    )
  end
end
