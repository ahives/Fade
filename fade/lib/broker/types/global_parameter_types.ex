defmodule Fade.Broker.GlobalParameterTypes do
  use TypedStruct

  typedstruct module: GlobalParameterInfo do
    field(:name, String.t())
    field(:value, any())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
