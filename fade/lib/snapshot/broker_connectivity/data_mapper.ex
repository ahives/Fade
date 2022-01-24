defmodule Fade.Snapshot.BrokerConnectivity.DataMapper do
  alias Fade.Snapshot.Types.{
    BrokerConnectivitySnapshot,
    ChannelSnapshot,
    ChurnMetrics,
    ConnectionSnapshot,
    NetworkTrafficSnapshot,
    Packets,
    QueueOperation,
    QueueOperationMetrics
  }

  alias Fade.Broker.SystemOverview.Types.SystemOverviewInfo
  alias Fade.Broker.Channel.Types.ChannelInfo
  alias Fade.Broker.Connection.Types.ConnectionInfo

  @spec map_data(
          system_overview :: SystemOverviewInfo.t(),
          connections :: list(ConnectionInfo),
          channels :: list(ChannelInfo)
        ) :: BrokerConnectivitySnapshot
  def map_data(system_overview, connections, channels) do
    BrokerConnectivitySnapshot.new(
      broker_version: system_overview.rabbitmq_version,
      cluster_name: system_overview.cluster_name,
      channels_closed:
        map_churn_metrics(
          system_overview.churn_rates.total_channels_closed,
          system_overview.churn_rates.closed_channel_details.value
        ),
      channels_created:
        map_churn_metrics(
          system_overview.churn_rates.total_channels_created,
          system_overview.churn_rates.created_channel_details.value
        ),
      connections_closed:
        map_churn_metrics(
          system_overview.churn_rates.total_connections_closed,
          system_overview.churn_rates.closed_connections_details.value
        ),
      connections_created:
        map_churn_metrics(
          system_overview.churn_rates.total_connections_created,
          system_overview.churn_rates.created_connection_details.value
        ),
      connections: map_connections(connections, channels)
    )
  end

  defp map_channels(nil, _connection_name) do
    nil
  end

  defp map_channels(channels, connection_name) do
    channels
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn channel ->
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
    end)
  end

  defp map_queue_operations(nil) do
    nil
  end

  defp map_queue_operations(operation_stats) do
    QueueOperationMetrics.new(
      incoming:
        map_queue_operation(
          operation_stats.total_messages_published,
          operation_stats.messages_published_details.value
        ),
      gets:
        map_queue_operation(
          operation_stats.total_message_gets,
          operation_stats.message_gets_details.value
        ),
      gets_without_ack:
        map_queue_operation(
          operation_stats.total_message_gets_without_ack,
          operation_stats.message_gets_without_ack_details.value
        ),
      delivered:
        map_queue_operation(
          operation_stats.total_messages_delivered,
          operation_stats.messages_delivered_details.value
        ),
      delivered_without_ack:
        map_queue_operation(
          operation_stats.total_message_delivered_without_ack,
          operation_stats.message_delivered_without_ack_details.value
        ),
      delivered_gets:
        map_queue_operation(
          operation_stats.total_message_delivery_gets,
          operation_stats.message_delivery_gets_details.value
        ),
      redelivered:
        map_queue_operation(
          operation_stats.total_messages_redelivered,
          operation_stats.messages_redelivered_details.value
        ),
      acknowledged:
        map_queue_operation(
          operation_stats.total_messages_acknowledged,
          operation_stats.messages_acknowledged_details.value
        ),
      not_routed:
        map_queue_operation(
          operation_stats.total_messages_not_routed,
          operation_stats.messages_not_routed_details.value
        )
    )
  end

  defp map_queue_operation(total, rate) do
    QueueOperation.new(total: total, rate: rate)
  end

  defp map_network_traffic(nil) do
    nil
  end

  defp map_network_traffic(connection) do
    NetworkTrafficSnapshot.new(
      max_frame_size: connection.max_frame_size_in_bytes,
      sent:
        map_packets(
          connection.packets_sent,
          connection.packet_bytes_sent,
          connection.packet_bytes_sent_details.value
        ),
      received:
        map_packets(
          connection.packets_received,
          connection.packet_bytes_received,
          connection.packet_bytes_received_details.value
        )
    )
  end

  defp map_packets(total, bytes, rate) do
    Packets.new(
      total: total,
      bytes: bytes,
      rate: rate
    )
  end

  defp map_connections(nil, _channels) do
    nil
  end

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

  defp map_churn_metrics(total, rate) do
    ChurnMetrics.new(total: total, rate: rate)
  end
end
