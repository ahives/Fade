defmodule Fade.Snapshot.Types do
  use TypedStruct

  typedstruct module: BrokerQueueChurnMetrics do
    field(:persisted, integer())
    field(:incoming, QueueDepth.t())
    field(:unacknowledged, QueueDepth.t())
    field(:ready, QueueDepth.t())
    field(:gets, QueueDepth.t())
    field(:gets_without_ack, QueueDepth.t())
    field(:delivered, QueueDepth.t())
    field(:delivered_without_ack, QueueDepth.t())
    field(:delivered_gets, QueueDepth.t())
    field(:redelivered, QueueDepth.t())
    field(:acknowledged, QueueDepth.t())
    field(:not_routed, QueueDepth.t())
    field(:broker, QueueDepth.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: QueueChurnMetrics do
    field(:incoming, QueueDepth.t())
    field(:unacknowledged, QueueDepth.t())
    field(:ready, QueueDepth.t())
    field(:gets, QueueDepth.t())
    field(:gets_without_ack, QueueDepth.t())
    field(:delivered, QueueDepth.t())
    field(:delivered_without_ack, QueueDepth.t())
    field(:delivered_gets, QueueDepth.t())
    field(:redelivered, QueueDepth.t())
    field(:acknowledged, QueueDepth.t())
    field(:aggregate, QueueDepth.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: RAM do
    field(:total, integer())
    field(:bytes, integer())
    field(:target, integer())
    field(:unacknowledged, integer())
    field(:ready, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default(), do: new(total: 0, bytes: 0, target: 0, unacknowledged: 0, ready: 0)
  end

  typedstruct module: PagedOut do
    field(:total, integer())
    field(:bytes, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default(), do: new(total: 0, bytes: 0)
  end

  typedstruct module: QueueMemoryDetails do
    field(:total, integer())
    field(:paged_out, PagedOut.t())
    field(:ram, RAM.t())

    def new(fields), do: struct!(__MODULE__, fields)

    def default(), do: new(total: 0, paged_out: PagedOut.default(), ram: RAM.default())
  end

  typedstruct module: QueueInternals do
    field(:reductions, Reductions.t())
    field(:target_count_of_messages_allowed_in_ram, integer())
    field(:consumer_utilization, integer())
    field(:q1, integer())
    field(:q2, integer())
    field(:q3, integer())
    field(:q4, integer())
    field(:avg_ingress_rate, integer())
    field(:avg_egress_rate, integer())
    field(:avg_acknowledgement_ingress_rate, integer())
    field(:avg_acknowledgement_egress_rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: Reductions do
    field(:total, integer())
    field(:rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: QueueDepth do
    field(:total, integer())
    field(:rate, Rate.t())

    def new(fields), do: struct!(__MODULE__, fields)

    def default, do: new(total: 0, rate: 0)
  end

  typedstruct module: DiskCapacityDetails do
    field(:available, integer())
    field(:rate, Rate.t())

    def new(fields), do: struct!(__MODULE__, fields)

    def default, do: new(available: 0, rate: 0)
  end

  typedstruct module: ChurnMetrics do
    field(:total, integer())
    field(:rate, Rate.t())

    def new(fields), do: struct!(__MODULE__, fields)

    def default(), do: new(total: 0, rate: 0)
  end

  typedstruct module: Packets do
    field(:total, integer())
    field(:bytes, integer())
    field(:rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default(), do: new(total: 0, bytes: 0, rate: 0.0)
  end

  typedstruct module: QueueOperation do
    field(:total, integer())
    field(:rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
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

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: FileDescriptorChurnMetrics do
    field(:available, integer())
    field(:used, integer())
    field(:usage_rate, integer())
    field(:open_attempts, integer())
    field(:open_attempt_rate, integer())
    field(:Avg_time_per_open_attempt, integer())
    field(:avg_time_rate_per_open_attempt, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: SocketDescriptorChurnMetrics do
    field(:available, integer())
    field(:used, integer())
    field(:usage_rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: Bytes do
    field(:Total, integer())
    field(:Rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: DiskOperationWallTime do
    field(:Average, integer())
    field(:Rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: DiskUsageDetails do
    field(:Total, integer())
    field(:Rate, integer())
    field(:Bytes, Bytes.t())
    field(:WallTime, DiskOperationWallTime.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: FileHandles do
    field(:Recycled, integer())
    field(:Rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: RuntimeProcessChurnMetrics do
    field(:limit, integer())
    field(:used, integer())
    field(:usage_rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: PersistenceDetails do
    field(:Total, integer())
    field(:Rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: TransactionDetails do
    field(:ram, PersistenceDetails.t())
    field(:disk, PersistenceDetails.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: JournalDetails do
    field(:Writes, IndexUsageDetails.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: IndexUsageDetails do
    field(:Total, integer())
    field(:Rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: IndexDetails do
    field(:Reads, IndexUsageDetails.t())
    field(:Writes, IndexUsageDetails.t())
    field(:Journal, JournalDetails.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: MessageStoreDetails do
    field(:Total, integer())
    field(:Rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: CollectedGarbage do
    field(:Total, integer())
    field(:Rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: GarbageCollection do
    field(:ChannelsClosed, CollectedGarbage.t())
    field(:ConnectionsClosed, CollectedGarbage.t())
    field(:QueuesDeleted, CollectedGarbage.t())
    field(:ReclaimedBytes, CollectedGarbage.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: StorageDetails do
    field(:Reads, MessageStoreDetails.t())
    field(:Writes, MessageStoreDetails.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: RuntimeDatabase do
    field(:Transactions, TransactionDetails.t())
    field(:Index, IndexDetails.t())
    field(:Storage, StorageDetails.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: IO do
    field(:reads, DiskUsageDetails.t())
    field(:writes, DiskUsageDetails.t())
    field(:seeks, DiskUsageDetails.t())
    field(:fileHandles, FileHandles.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: NodeIdentifier do
    field(:NodeIdentifier, String.t())
    field(:Capacity, DiskCapacityDetails.t())
    field(:Limit, integer())
    field(:AlarmInEffect, boolean())
    field(:io, IO.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: ContextSwitchingDetails do
    field(:Total, integer())
    field(:Rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
