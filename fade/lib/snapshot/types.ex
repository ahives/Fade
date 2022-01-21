defmodule Fade.Snapshot.Types do
  use TypedStruct

  typedstruct module: SnapshotResult do
    field(:identifier, String.t())
    field(:data, any())
    field(:timestamp, DateTime.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: ChurnMetrics do
    field(:total, integer())
    field(:rate, Rate.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: Packets do
    field(:total, integer())
    field(:bytes, integer())
    field(:rate, integer())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: NetworkTrafficSnapshot do
    field(:max_frame_size, String.t())
    field(:sent, Packets.t())
    field(:received, Packets.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: QueueOperation do
    field(:total, integer())
    field(:rate, integer())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: QueueOperationMetrics do
    field(:incoming, QueueOperation.t())
    field(:gets, QueueOperation.t())
    field(:gets_without_ack, QueueOperation.t())
    field(:delivered, QueueOperation.t())
    field(:delivered_without_ack, QueueOperation.t())
    field(:delivered_gets, QueueOperation.t())
    field(:redelivered, QueueOperation.t())
    field(:acknowledged, QueueOperation.t())
    field(:not_routed, QueueOperation.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: ChannelSnapshot do
    field(:prefetch_count, String.t())
    field(:uncommitted_acknowledgements, integer())
    field(:uncommitted_messages, integer())
    field(:unconfirmed_messages, integer())
    field(:unacknowledged_messages, integer())
    field(:consumers, integer())
    field(:identifier, String.t())
    field(:connection_identifier, integer())
    field(:node, integer())
    field(:queue_operations, QueueOperationMetrics.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: ConnectionSnapshot do
    field(:identifier, String.t())
    field(:network_traffic, NetworkTrafficSnapshot.t())
    field(:open_channels_limit, integer())
    field(:node_identifier, String.t())
    field(:virtual_host, String.t())

    field(
      :state,
      :starting
      | :tuning
      | :opening
      | :running
      | :flow
      | :blocking
      | :blocked
      | :closing
      | :closed
      | :inconclusive
    )

    field(:channels, list(ChannelSnapshot))

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: BrokerConnectivitySnapshot do
    field(:broker_version, String.t())
    field(:cluster_name, String.t())
    field(:channels_closed, ChurnMetrics.t())
    field(:channels_created, ChurnMetrics.t())
    field(:connections_closed, ChurnMetrics.t())
    field(:connections_created, ChurnMetrics.t())
    field(:connections, list(ConnectionSnapshot))

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end
end
