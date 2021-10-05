defmodule Fade.Types do
  use TypedStruct

  typedstruct module: BindingInfo do
    field(:source, String.t())
    field(:virtual_host, String.t())
    field(:destination, String.t())
    field(:destination_type, String.t())
    field(:routing_key, String.t())
    field(:arguments, Map.t(), default: %{})
    field(:properties_key, String.t())
  end
end
