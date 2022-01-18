defmodule Fade.Broker.Exchanges do
  alias Fade.Broker
  alias Fade.Broker.Core.DataMappings
  alias Fade.Broker.Exchange.Types.ExchangeInfo
  alias Fade.Config.Types.BrokerConfig

  @doc """
  Returns all exchanges on the current RabbitMQ node.
  """
  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/exchanges")
    |> DataMappings.map_result(&map_exchanges/1)
  end

  defp map_exchanges(exchanges) do
    exchanges
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn exchange ->
      ExchangeInfo.new(
        name: exchange["name"],
        vhost: exchange["vhost"],
        user_who_performed_action: exchange["user_who_performed_action"],
        routing_type: DataMappings.to_atom(exchange["routing_type"]),
        durable: exchange["durable"],
        auto_delete: exchange["auto_delete"],
        internal: exchange["internal"],
        arguments: exchange["arguments"]
      )
    end)
  end
end
