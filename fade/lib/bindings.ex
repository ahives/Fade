defmodule Fade.Bindings do
  use TypedStruct

  alias FadeInternal
  alias Fade.Sanitizer
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Broker.Types.BindingCriteria
  alias Fade.Broker

  typedstruct module: BindingDefinition do
    field(:routing_key, String.t())
    field(:arguments, map())

    def new(fields) do
      struct!(BindingDefinition, Keyword.merge([]))
    end
  end

  @doc """
  Returns all bindings on the current RabbitMQ node.
  """
  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/bindings")
  end

  @doc """
  Creates the specified binding between source (i.e. queue/exchange) and target (i.e. queue/exchange) on the target virtual host.
  """
  def create(config = %BrokerConfig{}, criteria = %BindingCriteria{}) do
    virtual_host = Sanitizer.to_sanitized_name(criteria.virtual_host)

    url =
      case criteria.type do
        :queue -> "api/bindings/#{virtual_host}/e/#{criteria.source}/q/#{criteria.destination}"
        _ -> "api/bindings/#{virtual_host}/e/#{criteria.source}/e/#{criteria.destination}"
      end

    definition = %BindingDefinition{
      routing_key: criteria.routing_key,
      arguments: criteria.arguments
    }

    Broker.post_request(config, url)
  end
end
