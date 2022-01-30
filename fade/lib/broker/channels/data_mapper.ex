defmodule Fade.Broker.Channel.DataMapper do
  alias Fade.Broker.Channel.Types.{
    ChannelOperationStats,
    ChannelInfo,
    ConnectionDetails,
    GarbageCollectionDetails
  }

  alias Fade.Broker.Core.PrimitiveDataMapper
  alias Fade.Broker.DataMapper

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn channel ->
      ChannelInfo.new(
        reduction_details: PrimitiveDataMapper.map_rate(channel["reduction_details"]),
        total_reductions: channel["total_reductions"],
        virtual_host: channel["virtual_host"],
        node: channel["node"],
        user: channel["user"],
        user_who_performed_action: channel["user_who_performed_action"],
        connected_at: channel["connected_at"],
        frame_max: channel["frame_max"],
        number: channel["number"],
        name: channel["name"],
        protocol: channel["protocol"],
        ssl_hash: channel["ssl_hash"],
        ssl_cipher: channel["ssl_cipher"],
        ssl_key_exchange: channel["ssl_key_exchange"],
        ssl_protocol: channel["ssl_protocol"],
        authentication_mechanism: channel["authentication_mechanism"],
        peer_certificate_validity: channel["peer_certificate_validity"],
        peer_certificate_issuer: channel["peer_certificate_issuer"],
        peer_certificate_subject: channel["peer_certificate_subject"],
        ssl: channel["ssl"],
        peer_host: PrimitiveDataMapper.to_atom(channel["peer_host"]),
        host: channel["host"],
        peer_port: channel["peer_port"],
        port: channel["port"],
        type: channel["type"],
        connection_details: map_connection_details(channel["connection_details"]),
        garbage_collection_details:
          map_garbage_collection_details(channel["garbage_collection_details"]),
        state: PrimitiveDataMapper.to_atom(channel["state"]),
        total_channels: channel["total_channels"],
        sent_pending: channel["sent_pending"],
        global_prefetch_count: channel["global_prefetch_count"],
        prefetch_count: channel["prefetch_count"],
        uncommitted_acknowledgements: channel["uncommitted_acknowledgements"],
        uncommitted_messages: channel["uncommitted_messages"],
        unacknowledged_messages: channel["unacknowledged_messages"],
        total_consumers: channel["total_consumers"],
        confirm: channel["confirm"],
        transactional: channel["transactional"],
        idle_since: channel["idle_since"],
        operation_stats: map_operation_stats(channel["operation_stats"])
      )
    end)
  end

  defp map_connection_details(nil) do
    nil
  end

  defp map_connection_details(data) do
    ConnectionDetails.new(
      peer_host: data["peer_host"],
      peer_port: data["peer_port"],
      name: data["name"]
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

  defp map_operation_stats(nil) do
    nil
  end

  defp map_operation_stats(data) do
    ChannelOperationStats.new(
      total_messages_published: data["total_messages_published"],
      messages_published_details:
        PrimitiveDataMapper.map_rate(data["messages_published_details"]),
      total_messages_confirmed: data["total_messages_confirmed"],
      messages_confirmed_details:
        PrimitiveDataMapper.map_rate(data["messages_confirmed_details"]),
      total_messages_not_routed: data["total_messages_not_routed"],
      messages_not_routed_details:
        PrimitiveDataMapper.map_rate(data["messages_not_routed_details"]),
      total_message_gets: data["total_message_gets"],
      message_gets_details: PrimitiveDataMapper.map_rate(data["message_gets_details"]),
      total_message_gets_without_ack: data["total_message_gets_without_ack"],
      message_gets_without_ack_details:
        PrimitiveDataMapper.map_rate(data["message_gets_without_ack_details"]),
      total_messages_delivered: data["total_messages_delivered"],
      messages_delivered_details:
        PrimitiveDataMapper.map_rate(data["messages_delivered_details"]),
      total_message_delivered_without_ack: data["total_message_delivered_without_ack"],
      message_delivered_without_ack_details:
        PrimitiveDataMapper.map_rate(data["message_delivered_without_ack_details"]),
      total_message_delivery_gets: data["total_message_delivery_gets"],
      message_delivery_gets_details:
        PrimitiveDataMapper.map_rate(data["message_delivery_gets_details"]),
      total_messages_redelivered: data["total_messages_redelivered"],
      messages_redelivered_details:
        PrimitiveDataMapper.map_rate(data["messages_redelivered_details"]),
      total_messages_acknowledged: data["total_messages_acknowledged"],
      messages_acknowledged_details:
        PrimitiveDataMapper.map_rate(data["messages_acknowledged_details"])
    )
  end
end
