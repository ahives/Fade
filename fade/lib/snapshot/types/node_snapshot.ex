defmodule Fade.Snapshot.Types.NodeSnapshot do
  use TypedStruct

  alias Fade.Snapshot.Types.{
    BrokerRuntimeSnapshot,
    ContextSwitchingDetails,
    DiskSnapshot,
    MemorySnapshot,
    OperatingSystemSnapshot
  }

  typedstruct do
    field(:operating_system, OperatingSystemSnapshot.t())
    field(:rates_mode, String.t())
    field(:uptime, integer())
    field(:inter_node_heartbeat, integer())
    field(:identifier, String.t())
    field(:cluster_identifier, String.t())
    field(:type, String.t())
    field(:is_running, boolean())
    field(:available_cores_detected, integer())
    field(:network_partitions, list(String))
    field(:disk, DiskSnapshot.t())
    field(:runtime, BrokerRuntimeSnapshot.t())
    field(:memory, MemorySnapshot.t())
    field(:context_switching, ContextSwitchingDetails.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
