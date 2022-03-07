defmodule Fade.Broker.UserTypes do
  use TypedStruct

  typedstruct module: UserInfo do
    field(:username, String.t())
    field(:password_hash, String.t())
    field(:hashing_algorithm, String.t())
    field(:tags, String.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
