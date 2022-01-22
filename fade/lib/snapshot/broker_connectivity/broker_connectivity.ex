defmodule Fade.Snapshot.BrokerConnectivity do
  alias Fade.Broker.{Channel, Connection, SystemOverview}
  alias Fade.Snapshot.BrokerConnectivity.DataMapper
  alias Fade.Snapshot.ResultMapper
  alias UUID

  def take_snapshot(config) do
    system_overview_result =
      Task.async(fn -> config |> SystemOverview.get end)
      |> Task.await()

    connection_result =
      Task.async(fn -> config |> Connection.get_all end)
      |> Task.await()

    channel_result =
      Task.async(fn -> config |> Channel.get_all end)
      |> Task.await()

    identifier = UUID.uuid1()

    DataMapper.map_data(system_overview_result.data, connection_result.data, channel_result.data)
    |> ResultMapper.map_result(identifier)
  end
end
