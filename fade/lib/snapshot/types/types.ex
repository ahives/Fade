defmodule Fade.Snapshot.Types do
  use TypedStruct

  typedstruct module: BrokerQueueChurnMetrics do
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

    def default, do: new(total: 0, rate: 0)
  end

  typedstruct module: Packets do
    field(:total, integer())
    field(:bytes, integer())
    field(:rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default, do: new(total: 0, bytes: 0, rate: 0.0)
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
    field(:avg_time_per_open_attempt, integer())
    field(:avg_time_rate_per_open_attempt, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default,
      do:
        new(
          available: 0,
          used: 0,
          usage_rate: 0,
          open_attempts: 0,
          open_attempt_rate: 0,
          avg_time_per_open_attempt: 0,
          avg_time_rate_per_open_attempt: 0
        )
  end

  typedstruct module: SocketDescriptorChurnMetrics do
    field(:available, integer())
    field(:used, integer())
    field(:usage_rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default, do: new(available: 0, used: 0, usage_rate: 0)
  end

  typedstruct module: Bytes do
    field(:total, integer())
    field(:rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default, do: new(total: 0, rate: 0)
  end

  typedstruct module: DiskOperationWallTime do
    field(:average, integer())
    field(:rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default, do: new(average: 0, rate: 0)
  end

  typedstruct module: DiskUsageDetails do
    field(:total, integer())
    field(:rate, integer())
    field(:bytes, Bytes.t())
    field(:wall_time, DiskOperationWallTime.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: FileHandles do
    field(:recycled, integer())
    field(:rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default, do: new(recycled: 0, rate: 0)
  end

  typedstruct module: RuntimeProcessChurnMetrics do
    field(:limit, integer())
    field(:used, integer())
    field(:usage_rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default, do: new(limit: 0, used: 0, usage_rate: 0)
  end

  typedstruct module: PersistenceDetails do
    field(:total, integer())
    field(:rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default, do: new(total: 0, rate: 0)
  end

  typedstruct module: TransactionDetails do
    field(:ram, PersistenceDetails.t())
    field(:disk, PersistenceDetails.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: JournalDetails do
    field(:writes, IndexUsageDetails.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: IndexUsageDetails do
    field(:total, integer())
    field(:rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default, do: new(total: 0, rate: 0)
  end

  typedstruct module: IndexDetails do
    field(:reads, IndexUsageDetails.t())
    field(:writes, IndexUsageDetails.t())
    field(:journal, JournalDetails.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: MessageStoreDetails do
    field(:total, integer())
    field(:rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default, do: new(total: 0, rate: 0)
  end

  typedstruct module: CollectedGarbage do
    field(:total, integer())
    field(:rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default, do: new(total: 0, rate: 0)
  end

  typedstruct module: GarbageCollection do
    field(:channels_closed, CollectedGarbage.t())
    field(:connections_closed, CollectedGarbage.t())
    field(:queues_deleted, CollectedGarbage.t())
    field(:reclaimed_bytes, CollectedGarbage.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: StorageDetails do
    field(:reads, MessageStoreDetails.t())
    field(:writes, MessageStoreDetails.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: RuntimeDatabase do
    field(:transactions, TransactionDetails.t())
    field(:index, IndexDetails.t())
    field(:storage, StorageDetails.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: IO do
    field(:reads, DiskUsageDetails.t())
    field(:writes, DiskUsageDetails.t())
    field(:seeks, DiskUsageDetails.t())
    field(:file_handles, FileHandles.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: NodeIdentifier do
    field(:node_identifier, String.t())
    field(:capacity, DiskCapacityDetails.t())
    field(:limit, integer())
    field(:alarm_in_effect, boolean())
    field(:io, IO.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: ContextSwitchingDetails do
    field(:total, integer())
    field(:rate, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default, do: new(total: 0, rate: 0)
  end
end
