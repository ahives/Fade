defmodule Fade.Broker.PolicyTypes do
  use TypedStruct

  typedstruct module: PolicyInfo do
    field(:virtual_host, String.t())
    field(:name, String.t())
    field(:pattern, String.t())
    field(:applied_to, String.t())
    field(:definition, map())
    field(:priority, integer())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
