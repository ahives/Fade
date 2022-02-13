defmodule Fade.Broker.CommonTypes do
  use TypedStruct

  typedstruct module: Rate do
    field(:value, integer())

    def new(fields), do: struct!(__MODULE__, fields)

    def default(), do: new(0.0)
  end
end
