defmodule Fade.Broker.UserDataMapper do
  alias Fade.Broker.DataMapper
  alias Fade.Broker.UserInfoTypes.UserInfo

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn vhost ->
      UserInfo.new(
        username: vhost["name"],
        password_hash: vhost["password_hash"],
        hashing_algorithm: vhost["hashing_algorithm"],
        tags: vhost["tags"]
      )
    end)
  end
end
