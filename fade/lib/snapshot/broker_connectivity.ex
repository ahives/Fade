defmodule Fade.Snapshot.BrokerConnectivity do
  alias Fade.Broker.{Channel, Connection, SystemOverview}
  alias Fade.Snapshot.BrokerConnectivity.DataMapper

  def take_snapshot(config) do
    system_overview_result = config |> SystemOverview.get()
    connection_result = config |> Connection.get_all()
    channel_result = config |> Channel.get_all()

    DataMapper.map_data(system_overview_result.data, connection_result.data, channel_result.data)
  end
end
