defmodule Fade.Snapshot.Mapper.BrokerQueuesMapper do
  alias Fade.Snapshot.Types.{
    BrokerQueueChurnMetrics,
    BrokerQueueSnapshot,
    PagedOut,
    QueueSnapshot,
    QueueChurnMetrics,
    QueueDepth,
    QueueMemoryDetails,
    RAM
  }

  alias Fade.Broker.Core.PrimitiveDataMapper
  alias Fade.Broker.SystemOverviewTypes.SystemOverviewInfo
  alias Fade.Broker.QueueTypes.QueueInfo

  @spec map_data(
          system_overview :: SystemOverviewInfo.t(),
          queues :: list(QueueInfo)
        ) :: BrokerQueueSnapshot.t()
  def map_data(system_overview, queues) do
    BrokerQueueSnapshot.new(
      cluster_name: system_overview.cluster_name,
      churn: map_churn_metrics(system_overview),
      queues: map_queues(queues)
    )
  end

  defp map_churn_metrics(system_overview) do
    BrokerQueueChurnMetrics.new(
      incoming:
        get_value(
          system_overview.message_stats,
          system_overview.message_stats.total_messages_published,
          system_overview.message_stats.messages_published_details
        ),
      not_routed:
        get_value(
          system_overview.message_stats,
          system_overview.message_stats.total_unroutable_messages,
          system_overview.message_stats.unroutable_messages_details
        ),
      gets:
        get_value(
          system_overview.message_stats,
          system_overview.message_stats.total_message_gets,
          system_overview.message_stats.message_get_details
        ),
      gets_without_ack:
        get_value(
          system_overview.message_stats,
          system_overview.message_stats.total_message_gets_without_ack,
          system_overview.message_stats.message_gets_without_ack_details
        ),
      delivered:
        get_value(
          system_overview.message_stats,
          system_overview.message_stats.total_messages_delivered,
          system_overview.message_stats.message_delivery_details
        ),
      delivered_without_ack:
        get_value(
          system_overview.message_stats,
          system_overview.message_stats.total_messages_delivered_without_ack,
          system_overview.message_stats.messages_delivered_without_ack_details
        ),
      delivered_gets:
        get_value(
          system_overview.message_stats,
          system_overview.message_stats.total_message_delivery_gets,
          system_overview.message_stats.message_delivery_get_details
        ),
      redelivered:
        get_value(
          system_overview.message_stats,
          system_overview.message_stats.total_messages_redelivered,
          system_overview.message_stats.messages_redelivered_details
        ),
      acknowledged:
        get_value(
          system_overview.message_stats,
          system_overview.message_stats.total_messages_acknowledged,
          system_overview.message_stats.messages_acknowledged_details
        ),
      broker:
        get_value(
          system_overview.queue_message_stats,
          system_overview.queue_message_stats.total_messages,
          system_overview.queue_message_stats.message_details
        ),
      ready:
        get_value(
          system_overview.queue_message_stats,
          system_overview.queue_message_stats.total_messages_ready_for_delivery,
          system_overview.queue_message_stats.messages_ready_for_delivery_details
        ),
      unacknowledged:
        get_value(
          system_overview.queue_message_stats,
          system_overview.queue_message_stats.total_unacknowledged_delivered_messages,
          system_overview.queue_message_stats.unacknowledged_delivered_message_details
        )
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
        consumers: queue.consumers,
        consumer_utilization: queue.consumer_utilization,
        idle_since: queue.idle_since
      )
    end)
  end

  defp map_queue_memory(nil), do: QueueMemoryDetails.default()

  defp map_queue_memory(queue) do
    QueueMemoryDetails.new(
      total: PrimitiveDataMapper.get_value(queue.memory),
      paged_out: map_paged_out(queue.total_messages_paged_out, queue.message_bytes_paged_out),
      ram: map_ram(queue)
    )
  end

  defp map_ram(queue) do
    RAM.new(
      total: PrimitiveDataMapper.get_value(queue.messages_in_ram),
      bytes: PrimitiveDataMapper.get_value(queue.message_bytes_in_ram),
      target:
        PrimitiveDataMapper.get_value(queue.backing_queue_status.target_total_messages_in_ram),
      unacknowledged: PrimitiveDataMapper.get_value(queue.unacknowledged_messages_in_ram),
      ready: PrimitiveDataMapper.get_value(queue.messages_ready_for_delivery_in_ram)
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
        get_value(
          queue.message_stats,
          queue.message_stats.total_messages_published,
          queue.message_stats.messages_published_details
        ),
      unacknowledged:
        get_value(
          queue.message_stats,
          queue.message_stats.total_messages_acknowledged,
          queue.message_stats.messages_acknowledged_details
        ),
      ready:
        get_value(
          queue,
          queue.ready_messages,
          queue.ready_message_details
        ),
      gets:
        get_value(
          queue.message_stats,
          queue.message_stats.total_message_gets,
          queue.message_stats.message_get_details
        ),
      gets_without_ack:
        get_value(
          queue.message_stats,
          queue.message_stats.total_message_gets_without_ack,
          queue.message_stats.message_gets_without_ack_details
        ),
      delivered:
        get_value(
          queue.message_stats,
          queue.message_stats.total_messages_delivered,
          queue.message_stats.message_delivery_details
        ),
      delivered_without_ack:
        get_value(
          queue.message_stats,
          queue.message_stats.total_messages_delivered_without_ack,
          queue.message_stats.messages_delivered_without_ack_details
        ),
      delivered_gets:
        get_value(
          queue.message_stats,
          queue.message_stats.total_message_delivery_gets,
          queue.message_stats.message_delivery_get_details
        ),
      redelivered:
        get_value(
          queue.message_stats,
          queue.message_stats.total_messages_redelivered,
          queue.message_stats.messages_redelivered_details
        ),
      acknowledged:
        get_value(
          queue.message_stats,
          queue.message_stats.total_messages_acknowledged,
          queue.message_stats.messages_acknowledged_details
        ),
      aggregate:
        get_value(
          queue,
          queue.total_messages,
          queue.message_details
        )
    )
  end

  defp get_value(nil, _total, _rate), do: QueueDepth.default()

  defp get_value(_data, total, rate) do
    map_queue_depth(
      PrimitiveDataMapper.get_value(total),
      PrimitiveDataMapper.get_rate_value(rate)
    )
  end

  defp map_queue_depth(nil, nil), do: QueueDepth.default()

  defp map_queue_depth(total, rate), do: QueueDepth.new(total: total, rate: rate)
end
