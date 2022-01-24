defmodule Fade.Snapshot.SnapshotResult do
  use TypedStruct

  typedstruct do
    field(:identifier, String.t())
    field(:data, any())
    field(:timestamp, DateTime.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end
end
