defmodule Fade.Broker.VirtualHost do
  alias Fade.Broker
  alias Fade.Broker.Core.ResultMapper
  alias Fade.Broker.VirtualHost.DataMapper
  alias Fade.Config.Types.BrokerConfig

  @doc """
  Returns information about each virtual host on the current RabbitMQ server.
  """
  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/vhosts")
    |> ResultMapper.map_result(&DataMapper.map_data/1)
  end
end
