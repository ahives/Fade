defmodule Fade.Broker.UserPermissionDataMapper do
  alias Fade.Broker.DataMapper
  alias Fade.Broker.UserPermissionTypes.UserPermissionsInfo

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn permisission ->
      UserPermissionsInfo.new(
        user: permisission["user"],
        virtual_host: permisission["vhost"],
        configure: permisission["configure"],
        write: permisission["write"],
        read: permisission["read"]
      )
    end)
  end
end
