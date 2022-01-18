defmodule Fade.Broker.Core.DataMappings do
  alias Fade.Broker.Core.Types.Rate

  alias Fade.Broker.Queue.Types.{
    BackingQueueStatus,
    GarbageCollectionDetails,
    QueueMessageStats,
    QueueInfo
  }

  def map_rate(data) do
    Rate.new(value: data["rate"])
  end

  def map_garbage_collection(data) do
    GarbageCollectionDetails.new(
      minor_garbage_collection: data["minor_garbage_collection"],
      full_sweep_after: data["full_sweep_after"],
      minimum_heap_size: data["minimum_heap_size"],
      minimum_binary_virtual_heap_size: data["minimum_binary_virtual_heap_size"],
      maximum_heap_size: data["maximum_heap_size"]
    )
  end

  def map_queue_message_stats(data) do
    QueueMessageStats.new(
      total_messages_published: data["total_messages_published"],
      messages_published_details: data["messages_published_details"],
      total_message_gets: data["total_message_gets"],
      message_get_details: data["message_get_details"],
      total_message_gets_without_ack: data["total_message_gets_without_ack"],
      message_gets_without_ack_details: map_rate(data["message_gets_without_ack_details"]),
      total_messages_delivered: data["total_messages_delivered"],
      message_delivery_details: map_rate(data["message_delivery_details"]),
      total_messages_delivered_without_ack: data["total_messages_delivered_without_ack"],
      messages_delivered_without_ack_details:
        map_rate(data["messages_delivered_without_ack_details"]),
      total_message_delivery_gets: data["total_message_delivery_gets"],
      message_delivery_get_details: map_rate(data["message_delivery_get_details"]),
      total_messages_redelivered: data["total_messages_redelivered"],
      messages_redelivered_details: map_rate(data["messages_redelivered_details"]),
      total_messages_acknowledged: data["total_messages_acknowledged"],
      messages_acknowledged_details: map_rate(data["messages_acknowledged_details"])
    )
  end

  def map_backing_queue_status(data) do
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

  def to_atom(data) do
    if is_nil(data) do
      nil
    else
      String.to_atom(data)
    end
  end
end
