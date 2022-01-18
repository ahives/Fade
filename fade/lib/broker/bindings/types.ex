defmodule Fade.Broker.Bindings.Types do
  use TypedStruct
  require Protocol

  alias Fade.Types.Error

  typedstruct module: ArgumentValue do
    field(:value, String.t())
    field(:error, %Error{})

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: BindingInfo do
    field(:source, String.t())
    field(:vhost, String.t())
    field(:destination, String.t())
    field(:destination_type, String.t())
    field(:routing_key, String.t())
    field(:arguments, map(), default: %{})
    field(:properties_key, String.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end

    # def from_map(map) do
    #   %BindingInfo{
    #     source: map.source,
    #     vhost: map.vhost,
    #     destination: map.destination,
    #     destination_type: map.destination_type,
    #     routing_key: map.routing_key,
    #     properties_key: map.properties_key
    #   }
    # end
  end

  typedstruct module: BindingCriteria do
    field(:source, String.t())
    field(:destination, String.t())
    field(:type, :queue | :exchange)
    field(:routing_key, String.t())
    field(:arguments, map())
    field(:virtual_host, String.t())
  end

  typedstruct module: BindingDefinition do
    field(:routing_key, String.t())
    field(:arguments, map())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  Protocol.derive(Jason.Encoder, Fade.Broker.Bindings.Types.BindingInfo)
end
