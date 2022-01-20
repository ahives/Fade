defmodule Fade.Broker.SystemOverview do
  require Logger

  alias Fade.Config.Types.BrokerConfig
  alias Fade.Broker
  alias Fade.Broker.Core.ResultMapper
  alias Fade.Broker.SystemOverview.DataMapper

  @doc """
  Returns various bits of random information that describe the RabbitMQ system.
  """
  def get(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_request("api/overview")
    |> ResultMapper.map_result(&DataMapper.map_data/1)
  end
end
