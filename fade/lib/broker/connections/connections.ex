defmodule Fade.Broker.Connections do
  use TypedStruct
  require Logger

  alias Fade.Config.Types.BrokerConfig
  alias Fade.Broker
  alias Fade.Broker.Connections.Mapper

  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/connections")
    |> DataMappings.map_result(&Mapper.map_connections/1)
  end
end
