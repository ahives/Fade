defmodule Fade.Bindings do
  use TypedStruct

  alias Fade.Sanitizer
  alias Fade.Types.BrokerConfig
  alias Fade.Broker.Types.BindingCriteria

  typedstruct module: BindingDefinition do
    field :routing_key, String.t()
    field :arguments, map()

    def new(fields) do
      struct!(BindingDefinition, Keyword.merge([]))
    end
  end

  @doc """
  Returns all bindings on the current RabbitMQ node.
  """
  def get_all(config = %BrokerConfig{}) do
    url = "api/bindings"

    Fade.get_all_request(config, url)
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

    Fade.post_request(config, url)
  end

  defp to() do
  end
end
