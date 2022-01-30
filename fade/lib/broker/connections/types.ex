defmodule Fade.Broker.Connection.Types do
  use TypedStruct

  alias Fade.Broker.Core.Types.Rate

  typedstruct module: GarbageCollectionDetails do
    field(:minor_garbage_collection, String.t())
    field(:full_sweepAfter, integer())
    field(:minimum_heap_size, integer())
    field(:minimum_binary_virtual_heap_size, integer())
    field(:maximum_heap_size, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: ConnectionCapabilities do
    field(:authentication_failure_notification_enabled, boolean())
    field(:negative_acknowledgment_notifications_enabled, boolean())
    field(:connection_blocked_notifications_enabled, boolean())
    field(:consumer_cancellation_notifications_enabled, boolean())
    field(:exchange_binding_enabled, boolean())
    field(:publisher_confirms_enabled, boolean())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: ConnectionClientProperties do
    field(:assembly, String.t())
    field(:assembly_version, String.t())
    field(:capabilities, ConnectionCapabilities.t())
    field(:client_api, String.t())
    field(:connected, DateTime.t())
    field(:connection_name, String.t())
    field(:copyright, String.t())
    field(:host, String.t())
    field(:information, String.t())
    field(:platform, String.t())
    field(:process_id, String.t())
    field(:process_name, String.t())
    field(:product, String.t())
    field(:version, String.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: ConnectionInfo do
    field(:reduction_details, Rate.t())
    field(:protocol, String.t())
    field(:total_reductions, integer())
    field(:packets_received, integer())
    field(:packet_bytes_received, integer())
    field(:packet_bytes_received_details, Rate.t())
    field(:packets_sent, integer())
    field(:packet_bytes_sent, integer())
    field(:packet_bytes_sent_details, Rate.t())
    field(:connected_at, integer())
    field(:open_channels_limit, integer())
    field(:max_frame_size_in_bytes, integer())
    field(:connection_timeout, integer())
    field(:virtual_host, String.t())
    field(:name, String.t())
    field(:channels, integer())
    field(:send_pending, integer())
    field(:type, :network)
    field(:garbage_collection_details, GarbageCollectionDetails.t())

    field(
      :state,
      :starting
      | :tuning
      | :opening
      | :running
      | :flow
      | :blocking
      | :blocked
      | :closing
      | :closed
      | :inconclusive
    )

    field(:ssl_hash_function, String.t())
    field(:ssl_cipher_algorithm, String.t())
    field(:ssl_key_exchange_algorithm, String.t())
    field(:ssl_protocol, String.t())
    field(:authentication_mechanism, String.t())
    field(:time_period_peer_certificate_valid, String.t())
    field(:peer_certificate_issuer, String.t())
    field(:peer_certificate_subject, String.t())
    field(:is_ssl, boolean())
    field(:peer_host, String.t())
    field(:host, String.t())
    field(:peer_port, integer())
    field(:port, integer())
    field(:node, String.t())
    field(:user, String.t())
    field(:user_who_performed_action, String.t())
    field(:connection_client_properties, ConnectionClientProperties.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
