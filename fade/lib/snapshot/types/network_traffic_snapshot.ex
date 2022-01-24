defmodule Fade.Snapshot.Types.NetworkTrafficSnapshot do
  use TypedStruct

  alias Fade.Snapshot.Types.Packets

  typedstruct do
    field(:max_frame_size, String.t())
    field(:sent, Packets.t())
    field(:received, Packets.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end
end
