defmodule Fade.Snapshot.Types.ClusterSnapshot do
  use TypedStruct

  alias Fade.Snapshot.Types.NodeSnapshot

  typedstruct do
    field(:broker_version, String.t())
    field(:cluster_name, String.t())
    field(:nodes, list(NodeSnapshot))

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
