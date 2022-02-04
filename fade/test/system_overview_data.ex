defmodule SystemOverviewData do
  alias Fade.Broker.SystemOverview.Types.{
    SystemOverviewInfo,
    Listener,
    ClusterObjectTotals,
    QueueMessageStats,
    SampleRetentionPolicies,
    ExchangeType,
    ChurnRates,
    MessageStats,
    NodeContext
  }

  alias Fade.Broker.Core.Types.Rate

  def get do
    SystemOverviewInfo.new(
      management_version: "3.7.15",
      rates_mode: "basic",
      sample_retention_policies:
        SampleRetentionPolicies.new(
          global: [
            600,
            3_600,
            28_800,
            86_400
          ],
          basic: [
            600,
            3_600
          ],
          detailed: [
            600
          ]
        ),
      exchange_types: [
        ExchangeType.new(
          name: "headers",
          description: "AMQP headers exchange, as per the AMQP specification",
          enabled: true
        ),
        ExchangeType.new(
          name: "fanout",
          description: "AMQP fanout exchange, as per the AMQP specification",
          enabled: true
        ),
        ExchangeType.new(
          name: "topic",
          description: "AMQP topic exchange, as per the AMQP specification",
          enabled: true
        ),
        ExchangeType.new(
          name: "direct",
          description: "AMQP direct exchange, as per the AMQP specification",
          enabled: true
        )
      ],
      product_version: "",
      product_name: "",
      rabbitmq_version: "3.7.15",
      cluster_name: "rabbit@haredu",
      erlang_version: "22.0.4",
      erlang_full_version:
        "Erlang/OTP 22 [erts-10.4.3] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:64] [hipe] [dtrace]",
      disable_stats: false,
      enable_queue_totals: false,
      message_stats:
        MessageStats.new(
          total_messages_published: 200_000,
          messages_published_details: Rate.new(value: 0.0),
          total_messages_confirmed: 200_000,
          message_confirmed_details: Rate.new(value: 0.0),
          total_unroutable_messages: 0,
          unroutable_messages_details: Rate.new(value: 0.0),
          total_disk_reads: 8734,
          disk_reads_details: Rate.new(value: 0.0),
          total_disk_writes: 200_000,
          disk_write_details: Rate.new(value: 0.0),
          total_message_gets: 7,
          message_get_details: Rate.new(value: 0.0),
          total_message_gets_without_ack: 0,
          message_gets_without_ack_details: Rate.new(value: 0.0),
          total_messages_delivered: 200_000,
          message_delivery_details: Rate.new(value: 0.0),
          total_messages_delivered_without_ack: 0,
          messages_delivered_without_ack_details: Rate.new(value: 0.0),
          total_message_delivery_gets: 200_007,
          message_delivery_get_details: Rate.new(value: 0.0),
          total_messages_redelivered: 7,
          messages_redelivered_details: Rate.new(value: 0.0),
          total_messages_acknowledged: 200_000,
          messages_acknowledged_details: Rate.new(value: 0.0)
        ),
      churn_rates:
        ChurnRates.new(
          total_channels_closed: 52,
          closed_channel_details: Rate.new(value: 0.0),
          total_channels_created: 61,
          created_channel_details: Rate.new(value: 0.0),
          total_connections_closed: 12,
          closed_connections_details: Rate.new(value: 0.0),
          total_connections_created: 14,
          created_connection_details: Rate.new(value: 0.0),
          total_queues_created: 8,
          created_queue_details: Rate.new(value: 0.0),
          total_queues_declared: 10,
          declared_queue_details: Rate.new(value: 0.0),
          total_queues_deleted: 5,
          deleted_queue_details: Rate.new(value: 0.0)
        ),
      queue_message_stats:
        QueueMessageStats.new(
          total_messages_ready_for_delivery: 3,
          messages_ready_for_delivery_details: Rate.new(value: 0.0),
          total_unacknowledged_delivered_messages: 0,
          unacknowledged_delivered_message_details: Rate.new(value: 0.0),
          total_messages: 3,
          message_details: Rate.new(value: 0.0)
        ),
      object_totals:
        ClusterObjectTotals.new(
          total_consumers: 3,
          total_queues: 11,
          total_exchanges: 100,
          total_connections: 2,
          total_channels: 3
        ),
      stats_database_event_queue: 0,
      node: "rabbit@localhost",
      listeners: [
        Listener.new(
          node: "rabbit@localhost",
          protocol: "amqp",
          ip_address: "127.0.0.1",
          port: 5672,
          socket_options: %{
            backlog: 128,
            nodelay: true,
            linger: [true, 0],
            exit_on_close: false
          }
        ),
        Listener.new(
          node: "rabbit@localhost",
          protocol: "clustering",
          ip_address: "::",
          port: 25_672,
          socket_options: []
        ),
        Listener.new(
          node: "rabbit@localhost",
          protocol: "http",
          ip_address: "::",
          port: 15_672,
          socket_options: %{
            cowboy_opts: %{sendfile: true},
            port: 15_672
          }
        ),
        Listener.new(
          node: "rabbit@localhost",
          protocol: "mqtt",
          ip_address: "::",
          port: 1883,
          socket_options: %{
            backlog: 128,
            nodelay: true
          }
        ),
        Listener.new(
          node: "rabbit@localhost",
          protocol: "stomp",
          ip_address: "::",
          port: 61_613,
          socket_options: %{
            backlog: 128,
            nodelay: true
          }
        )
      ],
      node_contexts:
        NodeContext.new(
          description: "RabbitMQ Management",
          path: "/",
          port: "15672",
          ssl_opts: [],
          node: "rabbit@localhost",
          cowboy_opts: "[{sendfile,false}]"
        )
    )
  end
end
