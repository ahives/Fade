defmodule Fade.Broker.NodeTypes do
  use TypedStruct

  alias Fade.Broker.Core.Types.Rate

  typedstruct module: GarbageCollectionMetrics do
    field(:connections_closed, integer())
    field(:channels_closed, integer())
    field(:consumers_deleted, integer())
    field(:exchanges_deleted, integer())
    field(:queues_deleted, integer())
    field(:virtual_hosts_deleted, integer())
    field(:nodes_deleted, integer())
    field(:channel_consumers_deleted, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default(),
      do:
        new(
          connections_closed: 0,
          channels_closed: 0,
          consumers_deleted: 0,
          exchanges_deleted: 0,
          queues_deleted: 0,
          virtual_hosts_deleted: 0,
          nodes_deleted: 0,
          channel_consumers_deleted: 0
        )
  end

  typedstruct module: ExchangeType do
    field(:name, String.t())
    field(:description, String.t())
    field(:is_enabled, boolean())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: AuthenticationMechanism do
    field(:name, String.t())
    field(:description, String.t())
    field(:is_enabled, boolean())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: Application do
    field(:name, String.t())
    field(:description, String.t())
    field(:version, String.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: NodeContext do
    field(:description, String.t())
    field(:path, String.t())
    field(:port, String.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: NodeInfo do
    field(:partitions, list(String))
    field(:operating_system_process_id, String.t())
    field(:total_file_descriptors, integer())
    field(:total_sockets_available, integer())
    field(:memory_limit, integer())
    field(:memory_alarm, boolean())
    field(:free_disk_limit, integer())
    field(:free_disk_alarm, boolean())
    field(:total_processes, integer())
    field(:rates_mode, :none | :basic | :detailed)
    field(:uptime, integer())
    field(:run_queue, integer())
    field(:type, String.t())
    field(:available_cores_detected, integer())
    field(:exchange_types, list(ExchangeType))
    field(:authentication_mechanisms, list(AuthenticationMechanism))
    field(:applications, list(Application))
    field(:contexts, list(NodeContext))
    field(:log_file, String.t())
    field(:log_files, list(String))
    field(:sasl_log_file, String.t())
    field(:database_directory, String.t())
    field(:config_files, list(String))
    field(:network_tick_time, integer())
    field(:enabled_plugins, list(String))
    field(:memory_calculation_strategy, String.t())
    field(:name, String.t())
    field(:is_running, boolean())
    field(:memory_used, integer())
    field(:memory_usage_details, Rate.t())
    field(:file_descriptor_used, integer())
    field(:file_descriptor_used_details, Rate.t())
    field(:sockets_used, integer())
    field(:sockets_used_details, String.t())
    field(:processes_used, integer())
    field(:process_usage_details, Rate.t())
    field(:free_disk_space, integer())
    field(:free_disk_space_details, Rate.t())
    field(:number_of_garbage_collected, integer())
    field(:gc_details, Rate.t())
    field(:bytes_reclaimed_by_garbage_collector, integer())
    field(:reclaimed_bytes_from_gc_details, Rate.t())
    field(:context_switches, integer())
    field(:context_switch_details, Rate.t())
    field(:total_io_reads, integer())
    field(:io_read_details, Rate.t())
    field(:total_io_bytes_read, integer())
    field(:io_bytes_read_details, Rate.t())
    field(:avg_io_read_time, integer())
    field(:avg_io_read_time_details, Rate.t())
    field(:total_io_writes, integer())
    field(:io_write_details, Rate.t())
    field(:total_io_bytes_written, integer())
    field(:io_bytes_written_details, Rate.t())
    field(:avg_time_per_io_write, integer())
    field(:avg_ime_per_io_write_details, Rate.t())
    field(:io_sync_count, integer())
    field(:io_syncs_details, Rate.t())
    field(:avg_io_sync_time, integer())
    field(:avg_io_sync_time_details, Rate.t())
    field(:io_seek_count, integer())
    field(:io_seeks_details, Rate.t())
    field(:avg_io_seek_time, integer())
    field(:avg_io_seek_time_details, Rate.t())
    field(:total_io_reopened, integer())
    field(:io_reopened_details, Rate.t())
    field(:total_mnesia_ram_transactions, integer())
    field(:mnesia_ram_transaction_count_details, Rate.t())
    field(:total_mnesia_disk_transactions, integer())
    field(:mnesia_disk_transaction_count_details, Rate.t())
    field(:total_message_store_reads, integer())
    field(:message_store_read_details, Rate.t())
    field(:total_message_store_writes, integer())
    field(:message_store_write_details, Rate.t())
    field(:total_queue_index_journal_writes, integer())
    field(:queue_index_journal_write_details, Rate.t())
    field(:total_queue_index_writes, integer())
    field(:queue_index_write_details, Rate.t())
    field(:total_queue_index_reads, integer())
    field(:queue_index_read_details, Rate.t())
    field(:total_open_file_handle_attempts, integer())
    field(:file_handle_open_attempt_details, Rate.t())
    field(:open_file_handle_attempts_avg_time, integer())
    field(:file_handle_open_attempt_avg_time_details, Rate.t())
    field(:garbage_collection_metrics, GarbageCollectionMetrics.t())
    field(:total_channels_closed, integer())
    field(:closed_channel_details, Rate.t())
    field(:total_channels_created, integer())
    field(:created_channel_details, Rate.t())
    field(:total_connections_closed, integer())
    field(:closed_connection_details, Rate.t())
    field(:total_connections_created, integer())
    field(:created_connection_details, Rate.t())
    field(:total_queues_created, integer())
    field(:created_queue_details, Rate.t())
    field(:total_queues_declared, integer())
    field(:declared_queue_details, Rate.t())
    field(:total_queues_deleted, integer())
    field(:deleted_queue_details, Rate.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
