defmodule Fade.Config.Types do
  use TypedStruct

  typedstruct module: FadeConfig do
    field(:base_url, String.t(), default: "http://localhost:15672/")
    field(:timeout, integer())
    field(:username, String.t(), default: "guest")
    field(:password, String.t(), default: "guest")
  end

  typedstruct module: BrokerConfig do
    field(:base_url, String.t())
    field(:headers, list(), default: [])
  end
end
