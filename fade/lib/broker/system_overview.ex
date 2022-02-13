defmodule Fade.Broker.SystemOverview do
  require Logger

  alias Fade.Broker
  alias Fade.Broker.SystemOverviewDataMapper, as: DataMapper
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Core.ResultMapper

  @doc """
  Returns various bits of random information that describe the RabbitMQ system.
  """
  def get(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_request("api/overview")
    |> ResultMapper.map_result(&DataMapper.map_data/1)
  end
end
