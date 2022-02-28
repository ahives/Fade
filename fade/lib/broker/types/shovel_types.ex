defmodule Fade.Broker.ShovelTypes do
  use TypedStruct

  typedstruct module: ShovelInfo do
    field(:node, String.t())
    field(:timestamp, DateTime.t())
    field(:name, String.t())
    field(:vhost, String.t())
    field(:type, :static | :dynamic)
    field(:state, :starting | :running | :terminated)

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
