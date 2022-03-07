defmodule Fade.Broker.ScopedParameterTypes do
  use TypedStruct

  typedstruct module: ScopedParameterInfo do
    field(:virtual_host, String.t())
    field(:component, String.t())
    field(:name, String.t())
    field(:value, map())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
