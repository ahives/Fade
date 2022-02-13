defmodule Fade.Broker.Channel do
  require Logger

  alias Fade.Broker
  alias Fade.Broker.ChannelDataMapper, as: DataMapper
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Core.ResultMapper

  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/channels")
    |> ResultMapper.map_result(&DataMapper.map_data/1)
  end
end
