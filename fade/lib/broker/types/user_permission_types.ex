defmodule Fade.Broker.UserPermissionTypes do
  use TypedStruct

  typedstruct module: UserPermissionsInfo do
    field(:user, String.t())
    field(:virtual_host, String.t())
    field(:configure, String.t())
    field(:write, String.t())
    field(:read, String.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
