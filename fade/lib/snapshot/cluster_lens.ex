defmodule Fade.Snapshot.ClusterLens do
  alias Fade.Broker.{SystemOverview, Node}
  alias Fade.Snapshot.Lens
  alias Fade.Snapshot.Mapper.ClusterMapper, as: DataMapper
  alias Fade.Snapshot.SnapshotResult
  alias UUID

  @behaviour Lens

  @impl Lens
  def take_snapshot(config) do
    system_overview_result =
      Task.async(fn -> config |> SystemOverview.get() end)
      |> Task.await()

    node_result =
      Task.async(fn -> config |> Node.get_all() end)
      |> Task.await()

    identifier = UUID.uuid1()

    DataMapper.map_data(system_overview_result.data, node_result.data)
    |> SnapshotResult.map_result(identifier)
  end
end
