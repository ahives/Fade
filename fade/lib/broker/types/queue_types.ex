defmodule Fade.Broker.QueueTypes do
  use TypedStruct

  alias Fade.Broker.Core.Types.Rate

  typedstruct module: GarbageCollectionDetails do
    field(:minor_garbage_collection, String.t())
    field(:full_sweep_after, integer())
    field(:minimum_heap_size, integer())
    field(:minimum_binary_virtual_heap_size, integer())
    field(:maximum_heap_size, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: BackingQueueStatus do
    field(:mode, :default | :lazy)
    field(:q1, integer())
    field(:q2, integer())
    field(:delta, list(any))
    field(:q3, integer())
    field(:q4, integer())
    field(:length, integer())
    field(:target_total_messages_in_ram, String.t())
    field(:next_sequence_id, integer())
    field(:avg_ingress_rate, integer())
    field(:avg_egress_rate, integer())
    field(:avg_acknowledgement_ingress_rate, integer())
    field(:avg_acknowledgement_egress_rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: QueueMessageStats do
    field(:total_messages_published, integer())
    field(:messages_published_details, Rate.t())
    field(:total_message_gets, integer())
    field(:message_get_details, Rate.t())
    field(:total_message_gets_without_ack, integer())
    field(:message_gets_without_ack_details, Rate.t())
    field(:total_messages_delivered, integer())
    field(:message_delivery_details, Rate.t())
    field(:total_messages_delivered_without_ack, integer())
    field(:messages_delivered_without_ack_details, Rate.t())
    field(:total_message_delivery_gets, integer())
    field(:message_delivery_get_details, Rate.t())
    field(:total_messages_redelivered, integer())
    field(:messages_redelivered_details, Rate.t())
    field(:total_messages_acknowledged, integer())
    field(:messages_acknowledged_details, Rate.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: QueueInfo do
    field(:message_details, Rate.t())
    field(:total_messages, integer())
    field(:unacknowledged_message_details, Rate.t())
    field(:unacknowledged_messages, integer())
    field(:ready_message_details, Rate.t())
    field(:ready_messages, integer())
    field(:reduction_details, Rate.t())
    field(:total_reduction, integer())
    field(:arguments, map())
    field(:exclusive, boolean())
    field(:auto_delete, boolean())
    field(:durable, boolean())
    field(:virtual_host, String.t())
    field(:name, String.t())
    field(:node, String.t())
    field(:message_bytes_paged_out, integer())
    field(:total_messages_paged_out, integer())
    field(:backing_queue_status, BackingQueueStatus.t())
    field(:head_message_timestamp, DateTime.t())
    field(:message_bytes_persisted, integer())
    field(:message_bytes_in_ram, integer())
    field(:total_bytes_of_messages_delivered_but_unacknowledged, integer())
    field(:total_bytes_of_messages_ready_for_delivery, integer())
    field(:total_bytes_of_all_messages, integer())
    field(:messages_persisted, integer())
    field(:unacknowledged_messages_in_ram, integer())
    field(:messages_ready_for_delivery_in_ram, integer())
    field(:messages_in_ram, integer())
    field(:gc, GarbageCollectionDetails.t())
    field(:state, :running | :idle)
    field(:recoverable_slaves, list(String))
    field(:consumers, integer())
    field(:exclusive_consumer_tag, String.t())
    field(:policy, String.t())
    field(:consumer_utilization, integer())
    field(:idle_since, DateTime.t())
    field(:memory, integer())
    field(:message_stats, QueueMessageStats.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
