defmodule Fade.Broker.TopicPermissionTypes do
  use TypedStruct

  typedstruct module: TopicPermissionsInfo do
    field(:user, String.t())
    field(:virtual_host, String.t())
    field(:exchange, String.t())
    field(:write, String.t())
    field(:read, String.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
