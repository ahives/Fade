defmodule Fade.Broker.Types do
  use TypedStruct
  require Protocol

  alias Fade.Types.Error

  typedstruct module: ArgumentValue do
    field :value, String.t()
    field :error, %Error{}
  end

  typedstruct module: BindingInfo do
    field :source, String.t()
    field :vhost, String.t()
    field :destination, String.t()
    field :destination_type, String.t()
    field :routing_key, String.t()
    field :arguments, map(), default: %{}
    field :properties_key, String.t()
  end

  typedstruct module: BindingCriteria do
    field :source, String.t()
    field :destination, String.t()
    field :type, :queue | :exchange
    field :routing_key, String.t()
    field :arguments, map()
    field :virtual_host, String.t()
  end

  Protocol.derive(Jason.Encoder, Fade.Broker.Types.BindingInfo)
end
