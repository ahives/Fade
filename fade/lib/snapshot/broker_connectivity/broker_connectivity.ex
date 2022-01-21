defmodule Fade.Snapshot.BrokerConnectivity do
  alias Fade.Broker.{Channel, Connection, SystemOverview}
  alias Fade.Snapshot.BrokerConnectivity.DataMapper
  alias Fade.Snapshot.ResultMapper
  alias UUID

  def take_snapshot(config) do
    system_overview_result = config |> SystemOverview.get()
    connection_result = config |> Connection.get_all()
    channel_result = config |> Channel.get_all()

    identifier = UUID.uuid1()

    DataMapper.map_data(system_overview_result.data, connection_result.data, channel_result.data)
    |> ResultMapper.map_result(identifier)
  end
end
