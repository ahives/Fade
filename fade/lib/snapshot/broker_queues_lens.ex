defmodule Fade.Snapshot.BrokerQueuesLens do
  alias Fade.Broker.{SystemOverview, Queue}
  alias Fade.Snapshot.Lens
  alias Fade.Snapshot.Mapper.BrokerQueuesMapper, as: DataMapper
  alias Fade.Snapshot.SnapshotResult
  alias UUID

  @behaviour Lens

  @impl Lens
  def take_snapshot(config) do
    system_overview_result =
      Task.async(fn -> config |> SystemOverview.get() end)
      |> Task.await()

    queue_result =
      Task.async(fn -> config |> Queue.get_all() end)
      |> Task.await()

    identifier = UUID.uuid1()

    DataMapper.map_data(system_overview_result.data, queue_result.data)
    |> SnapshotResult.map_result(identifier)
  end
end
