defmodule Fade.Snapshot.Types.ConnectionSnapshot do
  use TypedStruct

  alias Fade.Snapshot.Types.{ChannelSnapshot, NetworkTrafficSnapshot}

  typedstruct do
    field(:identifier, String.t())
    field(:network_traffic, NetworkTrafficSnapshot.t())
    field(:open_channels_limit, integer())
    field(:node_identifier, String.t())
    field(:virtual_host, String.t())

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

    field(:channels, list(ChannelSnapshot))

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end
end
