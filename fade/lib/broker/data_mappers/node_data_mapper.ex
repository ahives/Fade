defmodule Fade.Broker.NodeDataMapper do
  alias Fade.Broker.NodeTypes.{
    Application,
    AuthenticationMechanism,
    ExchangeType,
    GarbageCollectionMetrics,
    NodeContext,
    NodeInfo
  }

  alias Fade.Broker.DataMapper
  alias Fade.Broker.RateDataMapper

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn node ->
      NodeInfo.new(
        partitions: node["partitions"],
        operating_system_process_id: node["os_pid"],
        total_file_descriptors: node["fd_total"],
        total_sockets_available: node["sockets_total"],
        memory_limit: node["mem_limit"],
        memory_alarm: node["mem_alarm"],
        free_disk_limit: node["disk_free_limit"],
        free_disk_alarm: node["disk_free_alarm"],
        total_processes: node["proc_total"],
        rates_mode: node["rates_mode"],
        uptime: node["uptime"],
        run_queue: node["run_queue"],
        type: node["type"],
        available_cores_detected: node["processors"],
        exchange_types: map_exchange_types(node["exchange_types"]),
        authentication_mechanisms: map_auth_mechanisms(node["auth_mechanisms"]),
        applications: map_applications(node["applications"]),
        contexts: map_contexts(node["contexts"]),
        log_file: node["log_file"],
        log_files: node["log_files"],
        sasl_log_file: node["sasl_log_file"],
        database_directory: node["db_dir"],
        config_files: node["config_files"],
        network_tick_time: node["net_ticktime"],
        enabled_plugins: node["enabled_plugins"],
        memory_calculation_strategy: node["mem_calculation_strategy"],
        name: node["name"],
        is_running: node["running"],
        memory_used: node["mem_used"],
        memory_usage_details: RateDataMapper.map_rate(node["mem_used_details"]),
        sockets_used: node["sockets_used"],
        sockets_used_details: RateDataMapper.map_rate(node["sockets_used_details"]),
        processes_used: node["proc_used"],
        process_usage_details: RateDataMapper.map_rate(node["proc_used_details"]),
        free_disk_space: node["disk_free"],
        free_disk_space_details: RateDataMapper.map_rate(node["disk_free_details"]),
        number_of_garbage_collected: node["gc_num"],
        gc_details: RateDataMapper.map_rate(node["gc_num_details"]),
        bytes_reclaimed_by_garbage_collector: node["gc_bytes_reclaimed"],
        reclaimed_bytes_from_gc_details:
        RateDataMapper.map_rate(node["gc_bytes_reclaimed_details"]),
        context_switches: node["context_switches"],
        context_switch_details: RateDataMapper.map_rate(node["context_switches_details"]),
        total_io_reads: node["io_read_count"],
        io_read_details: RateDataMapper.map_rate(node["io_read_count_details"]),
        total_io_bytes_read: node["io_read_bytes"],
        io_bytes_read_details: RateDataMapper.map_rate(node["io_read_bytes_details"]),
        avg_io_read_time: node["io_read_avg_time"],
        avg_io_read_time_details: RateDataMapper.map_rate(node["io_read_avg_time_details"]),
        total_io_writes: node["io_write_count"],
        io_write_details: RateDataMapper.map_rate(node["io_write_count_details"]),
        total_io_bytes_written: node["io_write_bytes"],
        io_bytes_written_details: RateDataMapper.map_rate(node["io_write_bytes_details"]),
        avg_time_per_io_write: node["io_write_avg_time"],
        avg_ime_per_io_write_details: RateDataMapper.map_rate(node["io_write_avg_time_details"]),
        io_sync_count: node["io_sync_count"],
        io_syncs_details: RateDataMapper.map_rate(node["io_sync_count_details"]),
        avg_io_sync_time: node["io_sync_avg_time"],
        avg_io_sync_time_details: RateDataMapper.map_rate(node["io_sync_avg_time_details"]),
        io_seek_count: node["io_seek_count"],
        io_seeks_details: RateDataMapper.map_rate(node["io_seek_count_details"]),
        avg_io_seek_time: node["io_seek_avg_time"],
        avg_io_seek_time_details: RateDataMapper.map_rate(node["io_seek_avg_time_details"]),
        total_io_reopened: node["io_reopen_count"],
        io_reopened_details: RateDataMapper.map_rate(node["io_reopen_count_details"]),
        total_mnesia_ram_transactions: node["mnesia_ram_tx_count"],
        mnesia_ram_transaction_count_details:
          RateDataMapper.map_rate(node["mnesia_ram_tx_count_details"]),
        total_mnesia_disk_transactions: node["mnesia_disk_tx_count"],
        mnesia_disk_transaction_count_details:
          RateDataMapper.map_rate(node["mnesia_disk_tx_count_details"]),
        total_message_store_reads: node["msg_store_read_count"],
        message_store_read_details: RateDataMapper.map_rate(node["msg_store_read_count_details"]),
        total_message_store_writes: node["msg_store_write_count"],
        message_store_write_details:
          RateDataMapper.map_rate(node["msg_store_write_count_details"]),
        total_queue_index_journal_writes: node["queue_index_journal_write_count"],
        queue_index_journal_write_details:
          RateDataMapper.map_rate(node["queue_index_journal_write_count_details"]),
        total_queue_index_reads: node["queue_index_write_count"],
        queue_index_read_details:
          RateDataMapper.map_rate(node["queue_index_write_count_details"]),
        total_open_file_handle_attempts: node["io_file_handle_open_attempt_count"],
        file_handle_open_attempt_details:
          RateDataMapper.map_rate(node["io_file_handle_open_attempt_count_details"]),
        open_file_handle_attempts_avg_time: node["io_file_handle_open_attempt_avg_time"],
        file_handle_open_attempt_avg_time_details:
          RateDataMapper.map_rate(node["io_file_handle_open_attempt_avg_time_details"]),
        garbage_collection_metrics:
          map_garbage_collection_metrics(node["metrics_gc_queue_length"]),
        total_channels_closed: node["channel_closed"],
        closed_channel_details: RateDataMapper.map_rate(node["channel_closed_details"]),
        total_channels_created: node["channel_created"],
        created_channel_details: RateDataMapper.map_rate(node["channel_created_details"]),
        total_connections_closed: node["connection_closed"],
        closed_connection_details: RateDataMapper.map_rate(node["connection_closed_details"]),
        total_connections_created: node["connection_created"],
        created_connection_details: RateDataMapper.map_rate(node["connection_created_details"]),
        total_queues_created: node["queue_created"],
        created_queue_details: RateDataMapper.map_rate(node["queue_created_details"]),
        total_queues_declared: node["queue_declared"],
        declared_queue_details: RateDataMapper.map_rate(node["queue_declared_details"]),
        total_queues_deleted: node["queue_deleted"],
        deleted_queue_details: RateDataMapper.map_rate(node["queue_deleted_details"])
      )
    end)
  end

  defp map_contexts(nil), do: []

  defp map_contexts(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn context ->
      NodeContext.new(
        path: context["path"],
        description: context["description"],
        port: context["port"]
      )
    end)
  end

  defp map_applications(nil), do: []

  defp map_applications(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn application ->
      Application.new(
        name: application["name"],
        description: application["description"],
        version: application["version"]
      )
    end)
  end

  defp map_auth_mechanisms(nil), do: []

  defp map_auth_mechanisms(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn auth_mechanism ->
      AuthenticationMechanism.new(
        name: auth_mechanism["name"],
        description: auth_mechanism["description"],
        is_enabled: auth_mechanism["enabled"]
      )
    end)
  end

  defp map_exchange_types(nil), do: []

  defp map_exchange_types(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn exchange_type ->
      ExchangeType.new(
        name: exchange_type["name"],
        description: exchange_type["description"],
        is_enabled: exchange_type["enabled"]
      )
    end)
  end

  defp map_garbage_collection_metrics(nil), do: GarbageCollectionMetrics.default()

  defp map_garbage_collection_metrics(data) do
    GarbageCollectionMetrics.new(
      connections_closed: data["connection_closed"],
      channels_closed: data["channel_closed"],
      consumers_deleted: data["consumer_deleted"],
      exchanges_deleted: data["exchange_deleted"],
      queues_deleted: data["queue_deleted"],
      virtual_hosts_deleted: data["vhost_deleted"],
      nodes_deleted: data["node_node_deleted"],
      channel_consumers_deleted: data["channel_consumer_deleted"]
    )
  end
end
