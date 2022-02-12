defmodule Fade.Snapshot.Mapper.BrokerConnectivityMapper do
  alias Fade.Snapshot.Types.{
    BrokerConnectivitySnapshot,
    ChannelSnapshot,
    ChurnMetrics,
    ConnectionSnapshot,
    CollectedGarbage,
    NetworkTrafficSnapshot,
    Packets,
    QueueOperation,
    QueueOperationMetrics
  }

  alias Fade.Broker.Core.PrimitiveDataMapper
  alias Fade.Broker.SystemOverviewTypes.SystemOverviewInfo
  alias Fade.Broker.ChannelTypes.ChannelInfo
  alias Fade.Broker.ConnectionTypes.ConnectionInfo

  @spec map_data(
          system_overview :: SystemOverviewInfo.t(),
          connections :: list(ConnectionInfo),
          channels :: list(ChannelInfo)
        ) :: BrokerConnectivitySnapshot.t()
  def map_data(system_overview, connections, channels) do
    BrokerConnectivitySnapshot.new(
      broker_version: system_overview.rabbitmq_version,
      cluster_name: system_overview.cluster_name,
      channels_closed:
        get_churn_metrics(
          system_overview.churn_rates,
          system_overview.churn_rates.total_channels_closed,
          system_overview.churn_rates.closed_channel_details
        ),
      channels_created:
        get_churn_metrics(
          system_overview.churn_rates,
          system_overview.churn_rates.total_channels_created,
          system_overview.churn_rates.created_channel_details
        ),
      connections_closed:
        get_churn_metrics(
          system_overview.churn_rates,
          system_overview.churn_rates.total_connections_closed,
          system_overview.churn_rates.closed_connections_details
        ),
      connections_created:
        get_churn_metrics(
          system_overview.churn_rates,
          system_overview.churn_rates.total_connections_created,
          system_overview.churn_rates.created_connection_details
        ),
      connections: map_connections(connections, channels)
    )
  end

  defp get_churn_metrics(nil, _total, _rate), do: CollectedGarbage.default()

  defp get_churn_metrics(_data, total, rate) do
    map_churn_metrics(
      PrimitiveDataMapper.get_value(total),
      PrimitiveDataMapper.get_rate_value(rate)
    )
  end

  defp map_channels(nil, _connection_name), do: nil

  defp map_channels(channels, connection_name) do
    channels
    |> Stream.reject(&is_nil/1)
    |> Stream.map(fn channel ->
      if channel.connection_details.name == connection_name do
        ChannelSnapshot.new(
          prefetch_count: channel.prefetch_count,
          uncommitted_acknowledgements: channel.uncommitted_acknowledgements,
          uncommitted_messages: channel.uncommitted_messages,
          unconfirmed_messages: channel.unconfirmed_messages,
          unacknowledged_messages: channel.unacknowledged_messages,
          consumers: channel.total_consumers,
          identifier: channel.name,
          connection_identifier: connection_name,
          node: channel.node,
          queue_operations: map_queue_operations(channel.operation_stats)
        )
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  defp map_queue_operations(nil), do: nil

  defp map_queue_operations(operation_stats) do
    QueueOperationMetrics.new(
      incoming:
        get_queue_operation(
          operation_stats,
          operation_stats.total_messages_published,
          operation_stats.messages_published_details
        ),
      gets:
        get_queue_operation(
          operation_stats,
          operation_stats.total_message_gets,
          operation_stats.message_gets_details
        ),
      gets_without_ack:
        get_queue_operation(
          operation_stats,
          operation_stats.total_message_gets_without_ack,
          operation_stats.message_gets_without_ack_details
        ),
      delivered:
        get_queue_operation(
          operation_stats,
          operation_stats.total_messages_delivered,
          operation_stats.messages_delivered_details
        ),
      delivered_without_ack:
        get_queue_operation(
          operation_stats,
          operation_stats.total_message_delivered_without_ack,
          operation_stats.message_delivered_without_ack_details
        ),
      delivered_gets:
        get_queue_operation(
          operation_stats,
          operation_stats.total_message_delivery_gets,
          operation_stats.message_delivery_gets_details
        ),
      redelivered:
        get_queue_operation(
          operation_stats,
          operation_stats.total_messages_redelivered,
          operation_stats.messages_redelivered_details
        ),
      acknowledged:
        get_queue_operation(
          operation_stats,
          operation_stats.total_messages_acknowledged,
          operation_stats.messages_acknowledged_details
        ),
      not_routed:
        get_queue_operation(
          operation_stats,
          operation_stats.total_messages_not_routed,
          operation_stats.messages_not_routed_details
        )
    )
  end

  defp get_queue_operation(nil, _total, _rate), do: QueueOperation.default()

  defp get_queue_operation(_data, total, rate) do
    map_queue_operation(
      PrimitiveDataMapper.get_value(total),
      PrimitiveDataMapper.get_rate_value(rate)
    )
  end

  defp map_queue_operation(total, rate), do: QueueOperation.new(total: total, rate: rate)

  defp map_network_traffic(nil), do: NetworkTrafficSnapshot.default()

  defp map_network_traffic(connection) do
    NetworkTrafficSnapshot.new(
      max_frame_size: connection.max_frame_size_in_bytes,
      sent:
        get_packets(
          connection,
          connection.packets_sent,
          connection.packet_bytes_sent,
          connection.packet_bytes_sent_details.value
        ),
      received:
        get_packets(
          connection,
          connection.packets_received,
          connection.packet_bytes_received,
          connection.packet_bytes_received_details.value
        )
    )
  end

  defp get_packets(nil, _total, _bytes, _rate), do: Packets.default()

  defp get_packets(_data, total, bytes, rate) do
    map_packets(
      PrimitiveDataMapper.get_value(total),
      PrimitiveDataMapper.get_value(bytes),
      PrimitiveDataMapper.get_rate_value(rate)
    )
  end

  defp map_packets(total, bytes, rate), do: Packets.new(total: total, bytes: bytes, rate: rate)

  defp map_connections(nil, _channels), do: nil

  defp map_connections(connections, channels) do
    connections
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn connection ->
      ConnectionSnapshot.new(
        identifier: connection.name,
        network_traffic: map_network_traffic(connection),
        channels: map_channels(channels, connection.name),
        open_channels_limit: connection.open_channels_limit,
        node_identifier: connection.node,
        virtual_host: connection.virtual_host,
        state: connection.state
      )
    end)
  end

  defp map_churn_metrics(nil, rate), do: ChurnMetrics.new(total: 0, rate: rate)

  defp map_churn_metrics(total, nil), do: ChurnMetrics.new(total: total, rate: 0)

  defp map_churn_metrics(nil, nil), do: ChurnMetrics.default()

  defp map_churn_metrics(total, rate), do: ChurnMetrics.new(total: total, rate: rate)
end
