defmodule Fade.Broker.UserDataMapper do
  alias Fade.Broker.DataMapper
  alias Fade.Broker.UserInfoTypes.UserInfo

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn user ->
      UserInfo.new(
        username: user["name"],
        password_hash: user["password_hash"],
        hashing_algorithm: user["hashing_algorithm"],
        tags: user["tags"]
      )
    end)
  end
end
