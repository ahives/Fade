defmodule Fade.Broker.Core.Types do
  use TypedStruct

  typedstruct module: Rate do
    field(:value, integer())

    def new(fields) do
      struct!(Rate, fields)
    end
  end
end
