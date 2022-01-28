defmodule Fade.Snapshot.Types.BrokerQueueSnapshot do
  use TypedStruct

  # alias Fade.Snapshot.Types.{BrokerQueueChurnMetrics, QueueSnapshot}
  alias Fade.Snapshot.Types.QueueSnapshot

  typedstruct do
    field(:cluster_name, String.t())
    # field(:churn, BrokerQueueChurnMetrics.t())
    field(:queues, list(QueueSnapshot))

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
