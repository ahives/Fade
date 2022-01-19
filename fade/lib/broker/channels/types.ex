defmodule Fade.Broker.Channel.Types do
  use TypedStruct

  alias Fade.Broker.Core.Types.Rate

  typedstruct module: ChannelOperationStats do
    field(:total_messages_published, integer())
    field(:messages_published_details, Rate.t())
    field(:total_messages_confirmed, integer())
    field(:messages_confirmed_details, Rate.t())
    field(:total_messages_not_routed, integer())
    field(:messages_not_routed_details, Rate.t())
    field(:total_message_gets, integer())
    field(:message_gets_details, Rate.t())
    field(:total_message_gets_without_ack, integer())
    field(:message_gets_without_ack_details, Rate.t())
    field(:total_messages_delivered, integer())
    field(:messages_delivered_details, Rate.t())
    field(:total_message_delivered_without_ack, integer())
    field(:message_delivered_without_ack_details, Rate.t())
    field(:total_message_delivery_gets, integer())
    field(:message_delivery_gets_details, Rate.t())
    field(:total_messages_redelivered, integer())
    field(:messages_redelivered_details, Rate.t())
    field(:total_messages_acknowledged, integer())
    field(:messages_acknowledged_details, Rate.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: GarbageCollectionDetails do
    field(:minor_garbage_collection, String.t())
    field(:full_sweepAfter, integer())
    field(:minimum_heap_size, integer())
    field(:minimum_binary_virtual_heap_size, integer())
    field(:maximum_heap_size, integer())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: ConnectionDetails do
    field(:peer_host, String.t())
    field(:peer_port, integer())
    field(:name, String.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: ChannelInfo do
    field(:reduction_details, Rate.t())
    field(:total_reductions, integer())
    field(:virtual_host, String.t())
    field(:node, String.t())
    field(:user, String.t())
    field(:user_who_performed_action, String.t())
    field(:connected_at, integer())
    field(:frame_max, integer())
    field(:number, integer())
    field(:name, String.t())
    field(:protocol, String.t())
    field(:ssl_hash, String.t())
    field(:ssl_cipher, String.t())
    field(:ssl_key_exchange, String.t())
    field(:ssl_protocol, String.t())
    field(:authentication_mechanism, String.t())
    field(:peer_certificate_validity, String.t())
    field(:peer_certificate_issuer, String.t())
    field(:peer_certificate_subject, String.t())
    field(:ssl, boolean())
    field(:peer_host, String.t())
    field(:host, String.t())
    field(:peer_port, integer())
    field(:port, integer())
    field(:type, integer())
    field(:connection_details, ConnectionDetails.t())
    field(:garbage_collection_details, GarbageCollectionDetails.t())
    field(:state, :running | :idle)
    field(:total_channels, integer())
    field(:sent_pending, integer())
    field(:global_prefetch_count, integer())
    field(:prefetch_count, integer())
    field(:uncommitted_acknowledgements, integer())
    field(:uncommitted_messages, integer())
    field(:unconfirmed_messages, integer())
    field(:unacknowledged_messages, integer())
    field(:total_consumers, integer())
    field(:confirm, integer())
    field(:transactional, integer())
    field(:idle_since, integer())
    field(:operation_stats, ChannelOperationStats.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end
end
