defmodule Fade.Broker.SystemOverview.DataMapper do
  alias Fade.Broker.SystemOverview.Types.{
    SampleRetentionPolicies,
    ExchangeType,
    QueueMessageStats,
    ClusterObjectTotals,
    MessageStats,
    ChurnRates,
    SocketOptions,
    Listener,
    NodeContext,
    SystemOverviewInfo
  }

  alias Fade.Broker.Core.PrimitiveDataMapper

  def map_system_overview(system_overview) do
    SystemOverviewInfo.new(
      management_version: system_overview["management_version"],
      rates_mode: system_overview["rates_mode"],
      sample_retention_policies:
        map_sample_retention_policies(system_overview["sample_retention_policies"]),
      exchange_types: map_exchange_types(system_overview["exchange_types"]),
      product_version: system_overview["product_version"],
      product_name: system_overview["product_name"],
      rabbitmq_version: system_overview["rabbitmq_version"],
      cluster_name: system_overview["cluster_name"],
      erlang_version: system_overview["erlang_version"],
      erlang_full_version: system_overview["erlang_full_version"],
      disable_stats: system_overview["disable_stats"],
      enable_queue_totals: system_overview["enable_queue_totals"],
      message_stats: map_message_stats(system_overview["message_stats"]),
      churn_rates: map_churn_rates(system_overview["churn_rates"]),
      queue_message_stats: map_queue_message_stats(system_overview["queue_totals"]),
      object_totals: map_cluster_object_totals(system_overview["object_totals"]),
      stats_database_event_queue: system_overview["statistics_db_event_queue"],
      node: system_overview["node"],
      listeners: map_listeners(system_overview["listeners"]),
      node_contexts: map_node_contexts(system_overview["contexts"])
    )
  end

  defp map_node_contexts(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn context ->
      NodeContext.new(
        description: context["description"],
        path: context["path"],
        port: context["port"]
      )
    end)
  end

  defp map_listeners(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn listener ->
      Listener.new(
        node: listener["node"],
        protocol: listener["protocol"],
        ip_address: listener["ip_address"],
        port: listener["port"],
        socket_options: map_socket_options(listener["socket_opts"])
      )
    end)
  end

  defp map_socket_options(data) do
    if is_list(data) do
      []
    else
      SocketOptions.new(
        backlog: data["backlog"],
        no_delay: data["nodelay"],
        linger: data["linger"],
        exit_on_close: data["exit_on_close"],
        port: data["port"]
      )
    end
  end

  defp map_cluster_object_totals(data) do
    ClusterObjectTotals.new(
      total_consumers: data["consumers"],
      total_queues: data["queues"],
      total_exchanges: data["exchanges"],
      total_connections: data["connections"],
      total_channels: data["channels"]
    )
  end

  defp map_queue_message_stats(data) do
    QueueMessageStats.new(
      total_messages_ready_for_delivery: data["messages_ready"],
      messages_ready_for_delivery_details:
        PrimitiveDataMapper.map_rate(data["messages_ready_details"]),
      total_unacknowledged_delivered_messages: data["messages_unacknowledged"],
      unacknowledged_delivered_message_details:
        PrimitiveDataMapper.map_rate(data["messages_unacknowledged_details"]),
      total_messages: data["messages"],
      message_details: PrimitiveDataMapper.map_rate(data["messages_details"])
    )
  end

  defp map_churn_rates(data) do
    ChurnRates.new(
      total_channels_closed: data["channel_closed"],
      closed_channel_details: PrimitiveDataMapper.map_rate(data["channel_closed_details"]),
      total_channels_created: data["channel_created"],
      created_channel_details: PrimitiveDataMapper.map_rate(data["channel_created_details"]),
      total_connections_closed: data["connection_closed"],
      closed_connections_details: PrimitiveDataMapper.map_rate(data["connection_closed_details"]),
      total_connections_created: data["connection_created"],
      created_connection_details:
        PrimitiveDataMapper.map_rate(data["connection_created_details"]),
      total_queues_created: data["queue_created"],
      created_queue_details: PrimitiveDataMapper.map_rate(data["queue_created_details"]),
      total_queues_declared: data["queue_declared"],
      declared_queue_details: PrimitiveDataMapper.map_rate(data["queue_declared_details"]),
      total_queues_deleted: data["queue_deleted"],
      deleted_queue_details: PrimitiveDataMapper.map_rate(data["queue_deleted_details"])
    )
  end

  defp map_message_stats(data) do
    MessageStats.new(
      total_disk_reads: data["disk_reads"],
      disk_reads_details: PrimitiveDataMapper.map_rate(data["disk_reads_details"]),
      total_disk_writes: data["disk_writes"],
      disk_write_details: PrimitiveDataMapper.map_rate(data["disk_writes_details"]),
      total_messages_published: data["publish"],
      messages_published_details: PrimitiveDataMapper.map_rate(data["publish_details"]),
      total_messages_confirmed: data["confirm"],
      message_confirmed_details: PrimitiveDataMapper.map_rate(data["confirm_details"]),
      total_unroutable_messages: data["return_unroutable"],
      unroutable_messages_details:
        PrimitiveDataMapper.map_rate(data["return_unroutable_details"]),
      total_message_gets: data["get"],
      message_get_details: PrimitiveDataMapper.map_rate(data["get_details"]),
      total_message_gets_without_ack: data["get_no_ack"],
      message_gets_without_ack_details: PrimitiveDataMapper.map_rate(data["get_no_ack_details"]),
      total_messages_delivered: data["deliver"],
      message_delivery_details: PrimitiveDataMapper.map_rate(data["deliver_details"]),
      total_messages_delivered_without_ack: data["deliver_no_ack"],
      messages_delivered_without_ack_details:
        PrimitiveDataMapper.map_rate(data["deliver_no_ack_details"]),
      total_message_delivery_gets: data["deliver_get"],
      message_delivery_get_details: PrimitiveDataMapper.map_rate(data["deliver_get_details"]),
      total_messages_redelivered: data["redeliver"],
      messages_redelivered_details: PrimitiveDataMapper.map_rate(data["redeliver_details"]),
      total_messages_acknowledged: data["ack"],
      messages_acknowledged_details: PrimitiveDataMapper.map_rate(data["ack_details"])
    )
  end

  defp map_exchange_types(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn type ->
      ExchangeType.new(
        name: type["name"],
        description: type["description"],
        enabled: type["enabled"]
      )
    end)
  end

  defp map_sample_retention_policies(data) do
    SampleRetentionPolicies.new(
      global: data["global"],
      basic: data["basic"],
      detailed: data["detailed"]
    )
  end
end
