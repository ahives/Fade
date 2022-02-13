defmodule Fade.Snapshot.Mapper.ClusterMapper do
  alias Fade.Snapshot.Types.{
    BrokerRuntimeSnapshot,
    Bytes,
    ClusterSnapshot,
    CollectedGarbage,
    ContextSwitchingDetails,
    DiskSnapshot,
    DiskCapacityDetails,
    DiskOperationWallTime,
    DiskUsageDetails,
    FileDescriptorChurnMetrics,
    FileHandles,
    GarbageCollection,
    IO,
    IndexDetails,
    IndexUsageDetails,
    JournalDetails,
    MessageStoreDetails,
    MemorySnapshot,
    NodeSnapshot,
    OperatingSystemSnapshot,
    PersistenceDetails,
    RuntimeDatabase,
    RuntimeProcessChurnMetrics,
    StorageDetails,
    SocketDescriptorChurnMetrics,
    TransactionDetails
  }

  alias Fade.Core.PrimitiveDataMapper
  alias Fade.Broker.NodeTypes.NodeInfo
  alias Fade.Broker.RateDataMapper
  alias Fade.Broker.SystemOverviewTypes.SystemOverviewInfo

  @spec map_data(
          system_overview :: SystemOverviewInfo.t(),
          nodes :: list(NodeInfo)
        ) :: ClusterSnapshot.t()
  def map_data(system_overview, nodes) do
    ClusterSnapshot.new(
      broker_version: system_overview.rabbitmq_version,
      cluster_name: system_overview.cluster_name,
      nodes: map_nodes(system_overview, nodes)
    )
  end

  defp map_nodes(system_overview, nodes) do
    nodes
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn node ->
      NodeSnapshot.new(
        operating_system: map_operating_system(node),
        # rates_mode: node[""],
        uptime: node.uptime,
        # inter_node_heartbeat: node.network_tick_time,
        identifier: node.name,
        cluster_identifier: system_overview.cluster_name,
        type: node.type,
        is_running: node.is_running,
        available_cores_detected: node.available_cores_detected,
        network_partitions: node.partitions,
        disk: map_disk(node),
        runtime: map_runtime(system_overview, node),
        memory: map_memory(node),
        context_switching:
          get_context_switching(
            node,
            node.context_switches,
            node.context_switch_details
          )
      )
    end)
  end

  defp get_context_switching(nil, _total, _rate), do: ContextSwitchingDetails.default()

  defp get_context_switching(_data, total, rate) do
    map_context_switching(
      PrimitiveDataMapper.get_value(total),
      RateDataMapper.get_rate_value(rate)
    )
  end

  defp map_context_switching(nil, rate),
    do: ContextSwitchingDetails.new(total: 0, rate: rate)

  defp map_context_switching(total, nil),
    do: ContextSwitchingDetails.new(total: total, rate: 0)

  defp map_context_switching(nil, nil),
    do: ContextSwitchingDetails.default()

  defp map_context_switching(total, rate),
    do: ContextSwitchingDetails.new(total: total, rate: rate)

  defp map_memory(node) do
    MemorySnapshot.new(
      node_identifier: node.name,
      used: PrimitiveDataMapper.get_value(node.memory_used),
      usage_rate: RateDataMapper.get_rate_value(node.memory_usage_details),
      limit: PrimitiveDataMapper.get_value(node.memory_limit),
      alarm_in_effect: node.memory_alarm
    )
  end

  defp map_runtime(system_overview, node) do
    BrokerRuntimeSnapshot.new(
      identifier: node.name,
      cluster_identifier: system_overview.cluster_name,
      version: system_overview.erlang_version,
      processes:
        get_processes(
          node,
          node.total_processes,
          node.processes_used,
          node.process_usage_details
        ),
      database: map_database(node),
      gc: map_gc(node)
    )
  end

  defp map_gc(node) do
    GarbageCollection.new(
      channels_closed:
        get_collected_garbage(
          node,
          node.total_channels_closed,
          node.closed_channel_details
        ),
      connections_closed:
        get_collected_garbage(
          node,
          node.total_connections_closed,
          node.closed_connection_details
        ),
      queues_deleted:
        get_collected_garbage(
          node,
          node.total_queues_deleted,
          node.deleted_queue_details
        ),
      reclaimed_bytes:
        get_collected_garbage(
          node,
          node.bytes_reclaimed_by_garbage_collector,
          node.reclaimed_bytes_from_gc_details
        )
    )
  end

  defp get_collected_garbage(nil, _total, _rate), do: CollectedGarbage.default()

  defp get_collected_garbage(_data, total, rate) do
    map_collected_garbage(
      PrimitiveDataMapper.get_value(total),
      RateDataMapper.get_rate_value(rate)
    )
  end

  defp map_collected_garbage(nil, rate), do: CollectedGarbage.new(total: 0, rate: rate)

  defp map_collected_garbage(total, nil), do: CollectedGarbage.new(total: total, rate: 0)

  defp map_collected_garbage(nil, nil), do: CollectedGarbage.default()

  defp map_collected_garbage(total, rate), do: CollectedGarbage.new(total: total, rate: rate)

  defp get_index_usage(nil, _total, _rate), do: IndexUsageDetails.default()

  defp get_index_usage(_data, total, rate) do
    map_index_usage_details(
      PrimitiveDataMapper.get_value(total),
      RateDataMapper.get_rate_value(rate)
    )
  end

  defp map_index_usage_details(nil, rate), do: IndexUsageDetails.new(total: 0, rate: rate)

  defp map_index_usage_details(total, nil), do: IndexUsageDetails.new(total: total, rate: 0)

  defp map_index_usage_details(nil, nil), do: IndexUsageDetails.default()

  defp map_index_usage_details(total, rate), do: IndexUsageDetails.new(total: total, rate: rate)

  defp map_database(node) do
    RuntimeDatabase.new(
      transactions: map_transactions(node),
      index: map_index(node),
      storage: map_storage(node)
    )
  end

  defp map_storage(node) do
    StorageDetails.new(
      reads:
        get_message_store(
          node,
          node.total_message_store_reads,
          node.message_store_read_details
        ),
      writes:
        get_message_store(
          node,
          node.total_message_store_writes,
          node.message_store_write_details
        )
    )
  end

  defp get_message_store(nil, _total, _rate), do: MessageStoreDetails.default()

  defp get_message_store(_data, total, rate) do
    map_message_store_details(
      PrimitiveDataMapper.get_value(total),
      RateDataMapper.get_rate_value(rate)
    )
  end

  defp map_message_store_details(nil, rate), do: MessageStoreDetails.new(total: 0, rate: rate)

  defp map_message_store_details(total, nil), do: MessageStoreDetails.new(total: total, rate: 0)

  defp map_message_store_details(nil, nil), do: MessageStoreDetails.default()

  defp map_message_store_details(total, rate),
    do: MessageStoreDetails.new(total: total, rate: rate)

  defp map_index(node) do
    IndexDetails.new(
      reads:
        get_index_usage(
          node,
          node.total_queue_index_reads,
          node.queue_index_read_details
        ),
      writes:
        get_index_usage(
          node,
          node.total_queue_index_writes,
          node.queue_index_write_details
        ),
      journal: map_journal_details(node)
    )
  end

  defp map_journal_details(node) do
    JournalDetails.new(
      writes:
        get_index_usage(
          node,
          node.total_queue_index_journal_writes,
          node.queue_index_journal_write_details
        )
    )
  end

  defp map_transactions(node) do
    TransactionDetails.new(
      ram:
        get_persistence_details(
          node,
          node.total_mnesia_ram_transactions,
          node.mnesia_ram_transaction_count_details
        ),
      disk:
        get_persistence_details(
          node,
          node.total_mnesia_disk_transactions,
          node.mnesia_disk_transaction_count_details
        )
    )
  end

  defp get_persistence_details(nil, _total, _rate), do: PersistenceDetails.default()

  defp get_persistence_details(_data, total, rate) do
    map_persistence_details(
      PrimitiveDataMapper.get_value(total),
      RateDataMapper.get_rate_value(rate)
    )
  end

  defp map_persistence_details(nil, rate), do: PersistenceDetails.new(total: 0, rate: rate)

  defp map_persistence_details(total, nil), do: PersistenceDetails.new(total: total, rate: 0)

  defp map_persistence_details(nil, nil), do: PersistenceDetails.default()

  defp map_persistence_details(total, rate), do: PersistenceDetails.new(total: total, rate: rate)

  defp get_processes(nil, _limit, _used, _usage_rate), do: RuntimeProcessChurnMetrics.default()

  defp get_processes(_data, limit, used, usage_rate) do
    map_processes(
      PrimitiveDataMapper.get_value(limit),
      PrimitiveDataMapper.get_value(used),
      RateDataMapper.get_rate_value(usage_rate)
    )
  end

  defp map_processes(nil, used, usage_rate),
    do:
      RuntimeProcessChurnMetrics.new(
        limit: 0,
        used: used,
        usage_rate: usage_rate
      )

  defp map_processes(limit, nil, usage_rate),
    do:
      RuntimeProcessChurnMetrics.new(
        limit: limit,
        used: 0,
        usage_rate: usage_rate
      )

  defp map_processes(limit, used, nil),
    do:
      RuntimeProcessChurnMetrics.new(
        limit: limit,
        used: used,
        usage_rate: 0
      )

  defp map_processes(limit, nil, nil),
    do:
      RuntimeProcessChurnMetrics.new(
        limit: limit,
        used: 0,
        usage_rate: 0
      )

  defp map_processes(nil, nil, usage_rate),
    do:
      RuntimeProcessChurnMetrics.new(
        limit: 0,
        used: 0,
        usage_rate: usage_rate
      )

  defp map_processes(nil, used, nil),
    do:
      RuntimeProcessChurnMetrics.new(
        limit: 0,
        used: used,
        usage_rate: 0
      )

  defp map_processes(nil, nil, nil), do: RuntimeProcessChurnMetrics.default()

  defp map_processes(nil, used, usage_rate),
    do:
      RuntimeProcessChurnMetrics.new(
        limit: 0,
        used: used,
        usage_rate: usage_rate
      )

  defp map_processes(limit, used, usage_rate) do
    RuntimeProcessChurnMetrics.new(
      limit: limit,
      used: used,
      usage_rate: usage_rate
    )
  end

  defp map_disk(node) do
    DiskSnapshot.new(
      node_identifier: node.name,
      capacity: map_capacity(node),
      limit: PrimitiveDataMapper.get_value(node.free_disk_limit),
      alarm_in_effect: node.free_disk_alarm,
      io: map_io(node)
    )
  end

  defp map_io(node) do
    IO.new(
      reads:
        get_disk_usage(
          node,
          node.total_io_reads,
          node.io_read_details,
          node.total_io_bytes_read,
          node.io_bytes_read_details,
          node.avg_io_read_time,
          node.avg_io_read_time_details
        ),
      writes:
        get_disk_usage(
          node,
          node.total_io_writes,
          node.io_write_details,
          node.total_io_bytes_written,
          node.io_bytes_written_details,
          node.avg_time_per_io_write,
          node.avg_ime_per_io_write_details
        ),
      seeks:
        get_disk_usage(
          node,
          node.io_sync_count,
          node.io_syncs_details,
          node.avg_io_sync_time,
          node.avg_io_sync_time_details
        ),
      file_handles:
        get_file_handles(
          node,
          node.total_io_reopened,
          node.io_reopened_details
        )
    )
  end

  defp get_file_handles(nil, _recycled, _rate), do: FileHandles.default()

  defp get_file_handles(_data, recycled, rate) do
    map_file_handles(
      PrimitiveDataMapper.get_value(recycled),
      RateDataMapper.get_rate_value(rate)
    )
  end

  defp map_file_handles(nil, rate), do: FileHandles.new(recycled: 0, rate: rate)

  defp map_file_handles(recycled, nil), do: FileHandles.new(recycled: recycled, rate: 0)

  defp map_file_handles(nil, nil), do: FileHandles.default()

  defp map_file_handles(recycled, rate), do: FileHandles.new(recycled: recycled, rate: rate)

  defp get_disk_usage(
         nil,
         _total,
         _rate,
         _total_bytes,
         _total_bytes_rate,
         _wall_time,
         _wall_time_rate
       ),
       do: DiskUsageDetails.default()

  defp get_disk_usage(
         _data,
         total,
         rate,
         total_bytes,
         total_bytes_rate,
         wall_time,
         wall_time_rate
       ) do
    map_disk_usage_details(
      total,
      rate,
      total_bytes,
      total_bytes_rate,
      wall_time,
      wall_time_rate
    )
  end

  defp get_disk_usage(
         _data,
         total,
         rate,
         wall_time,
         wall_time_rate
       ) do
    DiskUsageDetails.new(
      total: PrimitiveDataMapper.get_value(total),
      rate: RateDataMapper.get_rate_value(rate),
      bytes: Bytes.new(total: 0, rate: 0.0),
      wall_time: map_wall_time(wall_time, wall_time_rate)
    )
  end

  defp map_disk_usage_details(
         total,
         rate,
         total_bytes,
         total_bytes_rate,
         wall_time,
         wall_time_rate
       ) do
    DiskUsageDetails.new(
      total: PrimitiveDataMapper.get_value(total),
      rate: RateDataMapper.get_rate_value(rate),
      bytes: map_bytes(total_bytes, total_bytes_rate),
      wall_time: map_wall_time(wall_time, wall_time_rate)
    )
  end

  defp map_wall_time(nil, rate),
    do: DiskOperationWallTime.new(average: 0, rate: RateDataMapper.get_rate_value(rate))

  defp map_wall_time(average, nil),
    do: DiskOperationWallTime.new(average: PrimitiveDataMapper.get_value(average), rate: 0.0)

  defp map_wall_time(nil, nil), do: DiskOperationWallTime.default()

  defp map_wall_time(average, rate),
    do:
      DiskOperationWallTime.new(
        average: PrimitiveDataMapper.get_value(average),
        rate: RateDataMapper.get_rate_value(rate)
      )

  defp map_bytes(nil, rate),
    do: Bytes.new(total: 0, rate: RateDataMapper.get_rate_value(rate))

  defp map_bytes(total, nil),
    do: Bytes.new(total: PrimitiveDataMapper.get_value(total), rate: 0.0)

  defp map_bytes(nil, nil), do: Bytes.default()

  defp map_bytes(total, rate),
    do:
      Bytes.new(
        total: PrimitiveDataMapper.get_value(total),
        rate: RateDataMapper.get_rate_value(rate)
      )

  defp map_capacity(nil), do: DiskCapacityDetails.default()

  defp map_capacity(node) do
    DiskCapacityDetails.new(
      available: PrimitiveDataMapper.get_value(node.free_disk_space),
      rate: RateDataMapper.get_rate_value(node.free_disk_space_details)
    )
  end

  defp map_operating_system(node) do
    OperatingSystemSnapshot.new(
      node_identifier: node.name,
      process_id: node.operating_system_process_id,
      file_descriptors: map_file_descriptors(node),
      socket_descriptors: map_socket_descriptors(node)
    )
  end

  defp map_socket_descriptors(nil), do: SocketDescriptorChurnMetrics.default()

  defp map_socket_descriptors(node) do
    SocketDescriptorChurnMetrics.new(
      available: PrimitiveDataMapper.get_value(node.total_sockets_available),
      used: PrimitiveDataMapper.get_value(node.sockets_used),
      usage_rate: RateDataMapper.get_rate_value(node.sockets_used_details)
    )
  end

  defp map_file_descriptors(nil), do: FileDescriptorChurnMetrics.default()

  defp map_file_descriptors(node) do
    FileDescriptorChurnMetrics.new(
      available: PrimitiveDataMapper.get_value(node.total_file_descriptors),
      used: PrimitiveDataMapper.get_value(node.file_descriptor_used),
      usage_rate: RateDataMapper.get_rate_value(node.file_descriptor_used_details),
      open_attempts: PrimitiveDataMapper.get_value(node.total_open_file_handle_attempts),
      open_attempt_rate:
      RateDataMapper.get_rate_value(node.file_handle_open_attempt_details),
      avg_time_per_open_attempt:
        PrimitiveDataMapper.get_value(node.open_file_handle_attempts_avg_time),
      avg_time_rate_per_open_attempt:
      RateDataMapper.get_rate_value(node.file_handle_open_attempt_avg_time_details)
    )
  end
end
