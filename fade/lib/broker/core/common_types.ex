defmodule Fade.Broker.Core.Types do
  use TypedStruct

  typedstruct module: Rate do
    field(:value, integer())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end
end
