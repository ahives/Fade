defmodule Fade.Broker.ExchangeDataMapper do
  alias Fade.Broker.Core.PrimitiveDataMapper
  alias Fade.Broker.DataMapper
  alias Fade.Broker.ExchangeTypes.ExchangeInfo

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
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
