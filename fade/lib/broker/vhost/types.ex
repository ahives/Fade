defmodule Fade.Broker.VirtualHost.Types do
  use TypedStruct

  alias Fade.Broker.Core.Types.Rate

  typedstruct module: MessageStats do
    field(:total_messages_published, integer())
    field(:messages_published_details, Rate.t())
    field(:total_messages_confirmed, integer())
    field(:messages_confirmed_details, Rate.t())
    field(:total_unroutable_messages, integer())
    field(:unroutable_message_details, Rate.t())
    field(:total_message_gets, integer())
    field(:message_get_details, Rate.t())
    field(:total_message_gets_without_ack, integer())
    field(:message_gets_without_ack_details, Rate.t())
    field(:total_messages_delivered, integer())
    field(:message_delivery_details, Rate.t())
    field(:total_messages_delivered_without_ack, integer())
    field(:messages_delivered_without_ack_details, Rate.t())
    field(:total_messages_redelivered, integer())
    field(:messages_redelivered_details, Rate.t())
    field(:total_messages_acknowledged, integer())
    field(:messages_acknowledged_details, Rate.t())
    field(:total_message_delivery_gets, integer())
    field(:message_delivery_gets_details, Rate.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: VirtualHostInfo do
    field(:name, String.t())
    field(:tracing, boolean())
    field(:cluster_state, map())
    field(:message_stats, MessageStats.t())
    field(:packet_bytes_received, integer())
    field(:packet_bytes_received_details, Rate.t())
    field(:packet_bytes_sent, integer())
    field(:packet_bytes_sent_details, Rate.t())
    field(:total_messages, integer())
    field(:message_details, Rate.t())
    field(:unacknowledged_messages, integer())
    field(:unacknowledged_message_details, Rate.t())
    field(:ready_messages, integer())
    field(:ready_message_details, Rate.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end
end
