defmodule Fade.Snapshot.Types do
  use TypedStruct

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

  typedstruct module: OperatingSystemSnapshot do
    field(:node_identifier, String.t())
    field(:process_id, String.t())
    field(:file_descriptors, FileDescriptorChurnMetrics.t())
    field(:socket_descriptors, SocketDescriptorChurnMetrics.t())
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

  typedstruct module: MemorySnapshot do
    field(:NodeIdentifier, String.t())
    field(:Used, integer())
    field(:UsageRate, integer())
    field(:Limit, integer())
    field(:AlarmInEffect, integer())
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

  typedstruct module: BrokerRuntimeSnapshot do
    field(:Identifier, String.t())
    field(:ClusterIdentifier, String.t())
    field(:Version, String.t())
    field(:Processes, RuntimeProcessChurnMetrics.t())
    field(:Database, RuntimeDatabase.t())
    field(:gc, GarbageCollection.t())
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

  typedstruct module: NodeSnapshot do
    field(:operating_system, OperatingSystemSnapshot.t())
    field(:rates_mode, String.t())
    field(:uptime, integer())
    field(:inter_node_heartbeat, integer())
    field(:identifier, String.t())
    field(:cluster_identifier, String.t())
    field(:type, String.t())
    field(:is_running, boolean())
    field(:available_cores_detected, integer())
    field(:network_partitions, list(String))
    field(:disk, DiskSnapshot.t())
    field(:runtime, BrokerRuntimeSnapshot.t())
    field(:memory, MemorySnapshot.t())
    field(:context_switching, ContextSwitchingDetails.t())
  end
end
