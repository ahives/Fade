defmodule Fade.Snapshot.Types.QueueSnapshot do
  use TypedStruct

  alias Fade.Snapshot.Types.{
    QueueChurnMetrics,
    QueueInternals,
    QueueMemoryDetails
  }

  typedstruct do
    field(:identifier, String.t())
    field(:virtual_host, String.t())
    field(:node, String.t())
    field(:messages, QueueChurnMetrics.t())
    field(:memory, QueueMemoryDetails.t())
    field(:internals, QueueInternals.t())
    field(:consumers, integer())
    field(:consumer_utilization, integer())
    field(:idle_since, DateTime.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
