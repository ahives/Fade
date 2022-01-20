defmodule Fade.Broker.VirtualHost.DataMapper do
  alias Fade.Broker.Core.PrimitiveDataMapper
  alias Fade.Broker.DataMapper
  alias Fade.Broker.VirtualHost.Types.{MessageStats, VirtualHostInfo}

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn virtual_host ->
      VirtualHostInfo.new(
        name: virtual_host["name"],
        tracing: virtual_host["tracing"],
        cluster_state: virtual_host["cluster_state"],
        message_stats: map_message_stats(virtual_host["message_stats"]),
        packet_bytes_received: virtual_host["packet_bytes_received"],
        packet_bytes_received_details:
          PrimitiveDataMapper.map_rate(virtual_host["packet_bytes_received_details"]),
        packet_bytes_sent: virtual_host["packet_bytes_sent"],
        packet_bytes_sent_details:
          PrimitiveDataMapper.map_rate(virtual_host["packet_bytes_sent_details"]),
        total_messages: virtual_host["total_messages"],
        message_details: PrimitiveDataMapper.map_rate(virtual_host["message_details"]),
        unacknowledged_messages: virtual_host["unacknowledged_messages"],
        unacknowledged_message_details:
          PrimitiveDataMapper.map_rate(virtual_host["unacknowledged_message_details"]),
        ready_messages: virtual_host["ready_messages"],
        ready_message_details: PrimitiveDataMapper.map_rate(virtual_host["ready_message_details"])
      )
    end)
  end

  defp map_message_stats(data) do
    MessageStats.new(
      total_messages_published: data["total_messages_published"],
      messages_published_details:
        PrimitiveDataMapper.map_rate(data["messages_published_details"]),
      total_messages_confirmed: data["total_messages_confirmed"],
      messages_confirmed_details:
        PrimitiveDataMapper.map_rate(data["messages_confirmed_details"]),
      total_unroutable_messages: data["total_unroutable_messages"],
      unroutable_message_details:
        PrimitiveDataMapper.map_rate(data["unroutable_message_details"]),
      total_message_gets: data["total_message_gets"],
      message_get_details: PrimitiveDataMapper.map_rate(data["message_get_details"]),
      total_message_gets_without_ack: data["total_message_gets_without_ack"],
      message_gets_without_ack_details:
        PrimitiveDataMapper.map_rate(data["message_gets_without_ack_details"]),
      total_messages_delivered: data["total_messages_delivered"],
      message_delivery_details: PrimitiveDataMapper.map_rate(data["message_delivery_details"]),
      total_messages_delivered_without_ack: data["total_messages_delivered_without_ack"],
      messages_delivered_without_ack_details:
        PrimitiveDataMapper.map_rate(data["messages_delivered_without_ack_details"]),
      total_messages_redelivered: data["total_messages_redelivered"],
      messages_redelivered_details:
        PrimitiveDataMapper.map_rate(data["messages_redelivered_details"]),
      total_messages_acknowledged: data["total_messages_acknowledged"],
      messages_acknowledged_details:
        PrimitiveDataMapper.map_rate(data["messages_acknowledged_details"]),
      total_message_delivery_gets: data["total_message_delivery_gets"],
      message_delivery_gets_details:
        PrimitiveDataMapper.map_rate(data["message_delivery_gets_details"])
    )
  end
end
