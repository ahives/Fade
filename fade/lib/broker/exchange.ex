defmodule Fade.Broker.Exchange do
  alias Fade.Broker
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Broker.Core.ResultMapper
  alias Fade.Broker.ExchangeDataMapper, as: DataMapper

  @doc """
  Returns all exchanges on the current RabbitMQ node.
  """
  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/exchanges")
    |> ResultMapper.map_result(&DataMapper.map_data/1)
  end
end