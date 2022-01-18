defmodule Fade.Broker.Exchange.Types do
  use TypedStruct

  typedstruct module: ExchangeInfo do
    field(:name, String.t())
    field(:vhost, String.t())
    field(:user_who_performed_action, String.t())
    field(:routing_type, :fanout | :direct | :topic | :headers | :federated | :match)
    field(:durable, boolean())
    field(:auto_delete, boolean())
    field(:internal, boolean())
    field(:arguments, map())

    def new(fields) do
      struct!(ExchangeInfo, fields)
    end
  end
end
