defmodule Fade.Snapshot.Types.OperatingSystemSnapshot do
  use TypedStruct

  alias Fade.Snapshot.Types.{FileDescriptorChurnMetrics, SocketDescriptorChurnMetrics}

  typedstruct do
    field(:node_identifier, String.t())
    field(:process_id, String.t())
    field(:file_descriptors, FileDescriptorChurnMetrics.t())
    field(:socket_descriptors, SocketDescriptorChurnMetrics.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
