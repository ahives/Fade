defmodule Fade.Snapshot.ResultMapper do
  alias Fade.Snapshot.Types.SnapshotResult

  def map_result(data, identifier) do
    SnapshotResult.new(
      identifier: identifier,
      data: data,
      timestamp: DateTime.utc_now()
    )
  end
end
