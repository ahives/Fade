defmodule Fade.Snapshot.Types.DiskSnapshot do
  use TypedStruct

  alias Fade.Snapshot.Types.{DiskCapacityDetails, IO}

  typedstruct do
    field(:node_identifier, String.t())
    field(:capacity, DiskCapacityDetails.t())
    field(:limit, integer())
    field(:alarm_in_effect, boolean())
    field(:io, IO.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
