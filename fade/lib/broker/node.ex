defmodule Fade.Broker.Node do
  alias Fade.Broker
  alias Fade.Broker.NodeDataMapper, as: DataMapper
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Core.ResultMapper

  @doc """
  Returns all nodes on the current RabbitMQ cluster.
  """
  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/nodes")
    |> ResultMapper.map_result(&DataMapper.map_data/1)
  end
end