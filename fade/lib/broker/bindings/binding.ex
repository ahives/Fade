defmodule Fade.Broker.Binding do
  require Logger

  alias Fade.Sanitizer
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Broker
  alias Fade.Broker.Bindings.Types.{BindingCriteria, BindingDefinition}
  alias Fade.Broker.Core.ResultMapper
  alias Fade.Broker.Bindings.DataMapper

  @doc """
  Returns all bindings on the current RabbitMQ node.
  """
  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/bindings")
    |> ResultMapper.map_result(&DataMapper.map_data/1)
  end

  @doc """
  Creates the specified binding between source (i.e. queue/exchange) and target (i.e. queue/exchange) on the target virtual host.
  """
  def create(config = %BrokerConfig{}, criteria = %BindingCriteria{}) when not is_nil(config) do
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

    config
    |> Broker.post_request(url, definition)
  end
end
