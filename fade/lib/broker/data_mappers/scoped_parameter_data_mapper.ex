defmodule Fade.Broker.ScopedParameterDataMapper do
  alias Fade.Broker.DataMapper
  alias Fade.Broker.ScopedParameterTypes.ScopedParameterInfo

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn parameter ->
      ScopedParameterInfo.new(
        virtual_host: parameter["vhost"],
        component: parameter["component"],
        name: parameter["name"],
        value: parameter["value"]
      )
    end)
  end
end
