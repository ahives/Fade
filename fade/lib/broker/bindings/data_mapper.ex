defmodule Fade.Broker.Bindings.DataMapper do
  alias Fade.Broker.Bindings.Types.BindingInfo

  def map_bindings(bindings) do
    bindings
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn binding ->
      BindingInfo.new(
        source: binding["source"],
        vhost: binding["vhost"],
        destination: binding["destination"],
        destination_type: binding["destination_type"],
        routing_key: binding["routing_key"],
        arguments: binding["arguments"],
        properties_key: binding["properties_key"]
      )
    end)
  end
end
