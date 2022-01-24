defmodule Fade.Snapshot.Types.BrokerRuntimeSnapshot do
  use TypedStruct

  alias Fade.Snapshot.Types.{GarbageCollection, RuntimeDatabase, RuntimeProcessChurnMetrics}

  typedstruct do
    field(:identifier, String.t())
    field(:cluster_identifier, String.t())
    field(:version, String.t())
    field(:processes, RuntimeProcessChurnMetrics.t())
    field(:database, RuntimeDatabase.t())
    field(:gc, GarbageCollection.t())
  end
end
