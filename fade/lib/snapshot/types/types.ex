defmodule Fade.Snapshot.Types do
  use TypedStruct

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

  typedstruct module: FileDescriptorChurnMetrics do
    field(:available, integer())
    field(:used, integer())
    field(:usage_rate, integer())
    field(:open_attempts, integer())
    field(:open_attempt_rate, integer())
    field(:Avg_time_per_open_attempt, integer())
    field(:avg_time_rate_per_open_attempt, integer())
  end

  typedstruct module: SocketDescriptorChurnMetrics do
    field(:available, integer())
    field(:used, integer())
    field(:usage_rate, integer())
  end

  typedstruct module: Bytes do
    field(:Total, integer())
    field(:Rate, integer())
  end

  typedstruct module: DiskOperationWallTime do
    field(:Average, integer())
    field(:Rate, integer())
  end

  typedstruct module: DiskUsageDetails do
    field(:Total, integer())
    field(:Rate, integer())
    field(:Bytes, Bytes.t())
    field(:WallTime, DiskOperationWallTime.t())
  end

  typedstruct module: FileHandles do
    field(:Recycled, integer())
    field(:Rate, integer())
  end

  typedstruct module: RuntimeProcessChurnMetrics do
    field(:limit, integer())
    field(:used, integer())
    field(:usage_rate, integer())
  end

  typedstruct module: PersistenceDetails do
    field(:Total, integer())
    field(:Rate, integer())
  end

  typedstruct module: TransactionDetails do
    field(:ram, PersistenceDetails.t())
    field(:disk, PersistenceDetails.t())
  end

  typedstruct module: JournalDetails do
    field(:Writes, IndexUsageDetails.t())
  end

  typedstruct module: IndexUsageDetails do
    field(:Total, integer())
    field(:Rate, integer())
  end

  typedstruct module: IndexDetails do
    field(:Reads, IndexUsageDetails.t())
    field(:Writes, IndexUsageDetails.t())
    field(:Journal, JournalDetails.t())
  end

  typedstruct module: MessageStoreDetails do
    field(:Total, integer())
    field(:Rate, integer())
  end

  typedstruct module: CollectedGarbage do
    field(:Total, integer())
    field(:Rate, integer())
  end

  typedstruct module: GarbageCollection do
    field(:ChannelsClosed, CollectedGarbage.t())
    field(:ConnectionsClosed, CollectedGarbage.t())
    field(:QueuesDeleted, CollectedGarbage.t())
    field(:ReclaimedBytes, CollectedGarbage.t())
  end

  typedstruct module: StorageDetails do
    field(:Reads, MessageStoreDetails.t())
    field(:Writes, MessageStoreDetails.t())
  end

  typedstruct module: RuntimeDatabase do
    field(:Transactions, TransactionDetails.t())
    field(:Index, IndexDetails.t())
    field(:Storage, StorageDetails.t())
  end

  typedstruct module: IO do
    field(:Reads, DiskUsageDetails.t())
    field(:Writes, DiskUsageDetails.t())
    field(:Seeks, DiskUsageDetails.t())
    field(:FileHandles, FileHandles.t())
  end

  typedstruct module: NodeIdentifier do
    field(:NodeIdentifier, String.t())
    field(:Capacity, DiskCapacityDetails.t())
    field(:Limit, integer())
    field(:AlarmInEffect, boolean())
    field(:io, IO.t())
  end

  typedstruct module: ContextSwitchingDetails do
    field(:Total, integer())
    field(:Rate, integer())
  end
end
