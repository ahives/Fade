defmodule Fade.Broker.TopicPermissionDataMapper do
  alias Fade.Broker.DataMapper
  alias Fade.Broker.TopicPermissionTypes.TopicPermissionsInfo

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn permisission ->
      TopicPermissionsInfo.new(
        user: permisission["user"],
        virtual_host: permisission["vhost"],
        exchange: permisission["exchange"],
        write: permisission["write"],
        read: permisission["read"]
      )
    end)
  end
end
