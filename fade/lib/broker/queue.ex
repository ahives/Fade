defmodule Fade.Broker.Queue do
  require Logger

  alias Fade.Config.Types.BrokerConfig
  alias Fade.Broker
  alias Fade.Broker.Core.ResultMapper
  alias Fade.Broker.Queue.DataMapper

  @doc """
  Returns all queues on the current RabbitMQ node.
  """
  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/queues")
    |> ResultMapper.map_result(&DataMapper.map_data/1)
  end
end
