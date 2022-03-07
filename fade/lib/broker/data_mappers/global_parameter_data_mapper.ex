defmodule Fade.Broker.GlobalParameterDataMapper do
  alias Fade.Broker.DataMapper
  alias Fade.Broker.GlobalParameterTypes.GlobalParameterInfo

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn parameter ->
      GlobalParameterInfo.new(
        name: parameter["name"],
        value: parameter["value"]
      )
    end)
  end
end
