defmodule Fade.Broker.Connection do
  require Logger

  alias Fade.Config.Types.BrokerConfig
  alias Fade.Broker
  alias Fade.Broker.Connection.DataMapper
  alias Fade.Broker.Core.ResultMapper

  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/connections")
    |> ResultMapper.map_result(&DataMapper.map_data/1)
  end
end
