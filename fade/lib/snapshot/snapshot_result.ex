defmodule Fade.Snapshot.SnapshotResult do
  use TypedStruct

  typedstruct do
    field(:identifier, String.t())
    field(:data, any())
    field(:timestamp, DateTime.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end

    def map_result(data, identifier) do
      new(
        identifier: identifier,
        data: data,
        timestamp: DateTime.utc_now()
      )
    end
  end
end
