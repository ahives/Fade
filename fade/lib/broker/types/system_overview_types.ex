defmodule Fade.Broker.SystemOverviewTypes do
  use TypedStruct

  alias Fade.Broker.CommonTypes.Rate

  typedstruct module: SampleRetentionPolicies do
    field(:global, list(integer))
    field(:basic, list(integer))
    field(:detailed, list(integer))

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: ExchangeType do
    field(:name, String.t())
    field(:description, String.t())
    field(:enabled, boolean())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: QueueMessageStats do
    field(:total_messages_ready_for_delivery, integer())
    field(:messages_ready_for_delivery_details, Rate.t())
    field(:total_unacknowledged_delivered_messages, integer())
    field(:unacknowledged_delivered_message_details, Rate.t())
    field(:total_messages, integer())
    field(:message_details, Rate.t())

    def new(fields), do: struct!(__MODULE__, fields)

    def default(),
      do:
        new(
          total_messages_ready_for_delivery: 0,
          messages_ready_for_delivery_details: Rate.default(),
          total_unacknowledged_delivered_messages: 0,
          unacknowledged_delivered_message_details: Rate.default(),
          total_messages: 0,
          message_details: Rate.default()
        )
  end

  typedstruct module: ClusterObjectTotals do
    field(:total_consumers, integer())
    field(:total_queues, integer())
    field(:total_exchanges, integer())
    field(:total_connections, integer())
    field(:total_channels, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default(),
      do:
        new(
          total_consumers: 0,
          total_queues: 0,
          total_exchanges: 0,
          total_connections: 0,
          total_channels: 0
        )
  end

  typedstruct module: MessageStats do
    field(:total_messages_published, integer())
    field(:messages_published_details, Rate.t())
    field(:total_messages_confirmed, integer())
    field(:message_confirmed_details, Rate.t())
    field(:total_unroutable_messages, integer())
    field(:unroutable_messages_details, Rate.t())
    field(:total_disk_reads, integer())
    field(:disk_reads_details, Rate.t())
    field(:total_disk_writes, integer())
    field(:disk_write_details, Rate.t())
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

  typedstruct module: ChurnRates do
    field(:total_channels_closed, integer())
    field(:closed_channel_details, Rate.t())
    field(:total_channels_created, integer())
    field(:created_channel_details, Rate.t())
    field(:total_connections_closed, integer())
    field(:closed_connections_details, Rate.t())
    field(:total_connections_created, integer())
    field(:created_connection_details, Rate.t())
    field(:total_queues_created, integer())
    field(:created_queue_details, Rate.t())
    field(:total_queues_declared, integer())
    field(:declared_queue_details, Rate.t())
    field(:total_queues_deleted, integer())
    field(:deleted_queue_details, Rate.t())

    def new(fields), do: struct!(__MODULE__, fields)

    def default(),
      do:
        new(
          total_channels_closed: 0,
          closed_channel_details: Rate.default(),
          total_channels_created: 0,
          created_channel_details: Rate.default(),
          total_connections_closed: 0,
          closed_connections_details: Rate.default(),
          total_connections_created: 0,
          created_connection_details: Rate.default(),
          total_queues_created: 0,
          created_queue_details: Rate.default(),
          total_queues_declared: 0,
          declared_queue_details: Rate.default(),
          total_queues_deleted: 0,
          deleted_queue_details: Rate.default()
        )
  end

  typedstruct module: SocketOptions do
    field(:backlog, integer())
    field(:no_delay, boolean())
    field(:linger, list(any))
    field(:exit_on_close, boolean())
    field(:cowboy_opts, map())
    field(:port, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: Listener do
    field(:node, String.t())
    field(:protocol, String.t())
    field(:ip_address, String.t())
    field(:port, String.t())
    field(:socket_options, any())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: NodeContext do
    field(:description, String.t())
    field(:path, String.t())
    field(:port, String.t())
    field(:ssl_opts, list(any))
    field(:node, String.t())
    field(:cowboy_opts, String.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: SystemOverviewInfo do
    field(:management_version, String.t())
    field(:rates_mode, String.t())
    field(:sample_retention_policies, SampleRetentionPolicies.t())
    field(:exchange_types, list(ExchangeType))
    field(:product_version, String.t())
    field(:product_name, String.t())
    field(:rabbitmq_version, String.t())
    field(:cluster_name, String.t())
    field(:erlang_version, integer())
    field(:erlang_full_version, String.t())
    field(:disable_stats, boolean())
    field(:enable_queue_totals, boolean())
    field(:message_stats, MessageStats.t())
    field(:churn_rates, ChurnRates.t())
    field(:queue_message_stats, QueueMessageStats.t())
    field(:object_totals, ClusterObjectTotals.t())
    field(:stats_database_event_queue, integer())
    field(:node, String.t())
    field(:listeners, list(Listener))
    field(:node_contexts, list(NodeContext))

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
