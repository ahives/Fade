defmodule Fade.Broker.Exchange.DataMapper do
  alias Fade.Broker.Core.PrimitiveDataMapper
  alias Fade.Broker.Exchange.Types.ExchangeInfo

  def map_exchanges(exchanges) do
    exchanges
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn exchange ->
      ExchangeInfo.new(
        name: exchange["name"],
        vhost: exchange["vhost"],
        user_who_performed_action: exchange["user_who_performed_action"],
        routing_type: PrimitiveDataMapper.to_atom(exchange["routing_type"]),
        durable: exchange["durable"],
        auto_delete: exchange["auto_delete"],
        internal: exchange["internal"],
        arguments: exchange["arguments"]
      )
    end)
  end
end
