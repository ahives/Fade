defmodule Fade.Broker.ShovelDataMapper do
  alias Fade.Broker.DataMapper
  alias Fade.Broker.ShovelTypes.ShovelInfo
  alias Fade.Core.PrimitiveDataMapper

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn shovel ->
      ShovelInfo.new(
        node: shovel["node"],
        timestamp: shovel["timestamp"],
        name: shovel["name"],
        vhost: shovel["vhost"],
        type: PrimitiveDataMapper.to_atom(shovel["type"]),
        state: PrimitiveDataMapper.to_atom(shovel["state"])
      )
    end)
  end
end
