defmodule Fade.Broker.VirtualHostLimitDataMapper do
  alias Fade.Broker.DataMapper
  alias Fade.Broker.VirtualHostLimitTypes.VirtualHostLimitInfo

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn vhost ->
      VirtualHostLimitInfo.new(
        vhost: vhost["vhost"],
        limits: vhost["value"]
      )
    end)
  end
end
