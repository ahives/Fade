defmodule Fade.Snapshot.Types.MemorySnapshot do
  use TypedStruct

  typedstruct do
    field(:node_identifier, String.t())
    field(:used, integer())
    field(:usage_rate, integer())
    field(:limit, integer())
    field(:alarm_in_effect, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
