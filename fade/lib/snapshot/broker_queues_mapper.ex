defmodule Fade.Snapshot.BrokerQueuesMapper do
  alias Fade.Snapshot.Types.{
    # BrokerQueueChurnMetrics,
    BrokerQueueSnapshot,
    PagedOut,
    QueueSnapshot,
    QueueChurnMetrics,
    QueueDepth,
    QueueMemoryDetails,
    RAM
  }

  alias Fade.Broker.SystemOverview.Types.SystemOverviewInfo
  alias Fade.Broker.Queue.Types.QueueInfo

  @spec map_data(
          system_overview :: SystemOverviewInfo.t(),
          queues :: list(QueueInfo)
        ) :: BrokerQueueSnapshot
  def map_data(system_overview, queues) do
    BrokerQueueSnapshot.new(
      cluster_name: system_overview.cluster_name,
      # churn: map_churn_metrics(queues),
      queues: map_queues(queues)
    )
  end

  defp map_queues(queues) do
    queues
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn queue ->
      QueueSnapshot.new(
        identifier: queue.name,
        virtual_host: queue.virtual_host,
        node: queue.node,
        messages: map_queue_churn_metrics(queue),
        memory: map_queue_memory(queue),
        # internals: queue.,
        consumers: queue.total_consumers,
        consumer_utilization: queue.consumer_utilization,
        idle_since: queue.idle_since
      )
    end)
  end

  defp map_queue_memory(nil), do: QueueMemoryDetails.default()

  defp map_queue_memory(queue) do
    QueueMemoryDetails.new(
      total: queue.memory,
      paged_out: map_paged_out(queue.total_messages_paged_out, queue.message_bytes_paged_out),
      ram: map_ram(queue)
    )
  end

  defp map_ram(queue) do
    RAM.new(
      total: queue.messages_in_ram,
      bytes: queue.message_bytes_in_ram,
      target: queue.backing_queue_status.target_total_messages_in_ram,
      unacknowledged: queue.unacknowledged_messages_in_ram,
      ready: queue.messages_ready_for_delivery_in_ram
    )
  end

  defp map_paged_out(nil, nil), do: PagedOut.default()

  defp map_paged_out(total_paged_out, nil), do: PagedOut.new(total: total_paged_out, bytes: 0)

  defp map_paged_out(nil, bytes_paged_out), do: PagedOut.new(total: 0, bytes: bytes_paged_out)

  defp map_paged_out(total_paged_out, bytes_paged_out),
    do: PagedOut.new(total: total_paged_out, bytes: bytes_paged_out)

  defp map_queue_churn_metrics(queue) do
    QueueChurnMetrics.new(
      incoming:
        map_queue_depth(
          queue.message_stats.total_messages_published,
          queue.message_stats.messages_published_details.value
        ),
      unacknowledged:
        map_queue_depth(
          queue.message_stats.total_messages_acknowledged,
          queue.message_stats.messages_acknowledged_details.value
        ),
      ready: map_queue_depth(queue.ready_messages, queue.ready_message_details.value),
      gets:
        map_queue_depth(
          queue.message_stats.total_message_gets,
          queue.message_stats.message_get_details.value
        ),
      gets_without_ack:
        map_queue_depth(
          queue.message_stats.total_message_gets_without_ack,
          queue.message_stats.message_gets_without_ack_details.value
        ),
      delivered:
        map_queue_depth(
          queue.message_stats.total_messages_delivered,
          queue.message_stats.message_delivery_details.value
        ),
      delivered_without_ack:
        map_queue_depth(
          queue.message_stats.total_messages_delivered_without_ack,
          queue.message_stats.messages_delivered_without_ack_details.value
        ),
      delivered_gets:
        map_queue_depth(
          queue.message_stats.total_message_delivery_gets,
          queue.message_stats.message_delivery_get_details.value
        ),
      redelivered:
        map_queue_depth(
          queue.message_stats.total_messages_redelivered,
          queue.message_stats.messages_redelivered_details.value
        ),
      acknowledged:
        map_queue_depth(
          queue.message_stats.total_messages_acknowledged,
          queue.message_stats.messages_acknowledged_details.value
        ),
      aggregate: map_queue_depth(queue.total_messages, queue.message_details.value)
    )
  end

  defp map_queue_depth(nil), do: QueueDepth.default()

  defp map_queue_depth(data), do: QueueDepth.new(total: data.total, rate: data.rate)
end
