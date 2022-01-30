defmodule Fade.Snapshot.Types.BrokerConnectivitySnapshot do
  use TypedStruct

  alias Fade.Snapshot.Types.{ChurnMetrics, ConnectionSnapshot}

  typedstruct do
    field(:broker_version, String.t())
    field(:cluster_name, String.t())
    field(:channels_closed, ChurnMetrics.t())
    field(:channels_created, ChurnMetrics.t())
    field(:connections_closed, ChurnMetrics.t())
    field(:connections_created, ChurnMetrics.t())
    field(:connections, list(ConnectionSnapshot))

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
