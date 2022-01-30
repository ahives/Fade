defmodule Fade.Snapshot.Types.NetworkTrafficSnapshot do
  use TypedStruct

  alias Fade.Snapshot.Types.Packets

  typedstruct do
    field(:max_frame_size, integer())
    field(:sent, Packets.t())
    field(:received, Packets.t())

    def new(fields), do: struct!(__MODULE__, fields)

    def default(), do: new(max_frame_size: 0, sent: Packets.default(), received: Packets.default())
  end
end
