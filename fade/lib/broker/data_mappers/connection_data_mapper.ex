defmodule Fade.Broker.ConnectionDataMapper do
  alias Fade.Broker.ConnectionTypes.{
    ConnectionCapabilities,
    ConnectionClientProperties,
    ConnectionInfo,
    GarbageCollectionDetails
  }

  alias Fade.Broker.DataMapper
  alias Fade.Broker.RateDataMapper
  alias Fade.Core.PrimitiveDataMapper

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn connection ->
      ConnectionInfo.new(
        reduction_details: RateDataMapper.map_rate(connection["reduction_details"]),
        protocol: connection["protocol"],
        total_reductions: connection["total_reductions"],
        packets_received: connection["packets_received"],
        packet_bytes_received: connection["packet_bytes_received"],
        packet_bytes_received_details:
          RateDataMapper.map_rate(connection["packet_bytes_received_details"]),
        packets_sent: connection["packets_sent"],
        packet_bytes_sent: connection["packet_bytes_sent"],
        packet_bytes_sent_details:
          RateDataMapper.map_rate(connection["packet_bytes_sent_details"]),
        connected_at: connection["connected_at"],
        open_channels_limit: connection["open_channels_limit"],
        max_frame_size_in_bytes: connection["max_frame_size_in_bytes"],
        connection_timeout: connection["connection_timeout"],
        virtual_host: connection["virtual_host"],
        name: connection["name"],
        channels: connection["channels"],
        send_pending: connection["send_pending"],
        type: String.to_atom(connection["type"]),
        garbage_collection_details:
          map_garbage_collection_details(connection["garbage_collection_details"]),
        state: PrimitiveDataMapper.to_atom(connection["state"]),
        ssl_hash_function: connection["ssl_hash_function"],
        ssl_cipher_algorithm: connection["ssl_cipher_algorithm"],
        ssl_key_exchange_algorithm: connection["ssl_key_exchange_algorithm"],
        ssl_protocol: connection["ssl_protocol"],
        authentication_mechanism: connection["authentication_mechanism"],
        time_period_peer_certificate_valid: connection["time_period_peer_certificate_valid"],
        peer_certificate_issuer: connection["peer_certificate_issuer"],
        peer_certificate_subject: connection["peer_certificate_subject"],
        is_ssl: connection["is_ssl"],
        peer_host: PrimitiveDataMapper.to_atom(connection["peer_host"]),
        host: connection["host"],
        peer_port: connection["peer_port"],
        port: connection["port"],
        node: connection["node"],
        user: connection["user"],
        user_who_performed_action: connection["user_who_performed_action"],
        connection_client_properties:
          map_connection_client_properties(connection["connection_client_properties"])
      )
    end)
  end

  defp map_capabilities(nil) do
    nil
  end

  defp map_capabilities(data) do
    ConnectionCapabilities.new(
      authentication_failure_notification_enabled:
        data["authentication_failure_notification_enabled"],
      negative_acknowledgment_notifications_enabled:
        data["negative_acknowledgment_notifications_enabled"],
      connection_blocked_notifications_enabled: data["connection_blocked_notifications_enabled"],
      consumer_cancellation_notifications_enabled:
        data["consumer_cancellation_notifications_enabled"],
      exchange_binding_enabled: data["exchange_binding_enabled"],
      publisher_confirms_enabled: data["publisher_confirms_enabled"]
    )
  end

  defp map_connection_client_properties(nil) do
    nil
  end

  defp map_connection_client_properties(data) do
    ConnectionClientProperties.new(
      assembly: data["assembly"],
      assembly_version: data["assembly_version"],
      capabilities: map_capabilities(data["capabilities"]),
      client_api: data["client_api"],
      connected: data["connected"],
      connection_name: data["connection_name"],
      copyright: data["copyright"],
      host: data["host"],
      information: data["information"],
      platform: data["platform"],
      process_id: data["process_id"],
      process_name: data["process_name"],
      product: data["product"],
      version: data["version"]
    )
  end

  defp map_garbage_collection_details(nil) do
    nil
  end

  defp map_garbage_collection_details(data) do
    GarbageCollectionDetails.new(
      minor_garbage_collection: data["minor_garbage_collection"],
      full_sweepAfter: data["full_sweepAfter"],
      minimum_heap_size: data["minimum_heap_size"],
      minimum_binary_virtual_heap_size: data["minimum_binary_virtual_heap_size"],
      maximum_heap_size: data["maximum_heap_size"]
    )
  end
end
