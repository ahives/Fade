defmodule Fade.Snapshot.Types.ChannelSnapshot do
  use TypedStruct

  alias Fade.Snapshot.Types.QueueOperationMetrics

  typedstruct do
    field(:prefetch_count, integer())
    field(:uncommitted_acknowledgements, integer())
    field(:uncommitted_messages, integer())
    field(:unconfirmed_messages, integer())
    field(:unacknowledged_messages, integer())
    field(:consumers, integer())
    field(:identifier, String.t())
    field(:connection_identifier, integer())
    field(:node, integer())
    field(:queue_operations, QueueOperationMetrics.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
