defmodule Fade.Snapshot.Lens do
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Snapshot.SnapshotResult

  @callback take_snapshot(config :: BrokerConfig.t()) :: SnapshotResult.t()
end
