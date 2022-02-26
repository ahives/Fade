defmodule Fade.Broker.Binding do
  require Logger

  alias Fade.Sanitizer
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Broker
  alias Fade.Broker.BindingTypes.{BindingCriteria, BindingDefinition}
  alias Fade.Broker.BindingDataMapper, as: DataMapper
  alias Fade.Core.ResultMapper
  alias Fade.{ConfigurationMissingError, RabbitMqServerResponseError}

  @doc """
  Returns all bindings on the current RabbitMQ node.
  """
  @spec get_all(config :: BrokerConfig.t()) ::
          {:ok, Result.t()}
          | {:error, ConfigurationMissingError.t()}
          | {:error, RabbitMqServerResponseError.t()}
  def get_all(nil) do
    {:error, %ConfigurationMissingError{message: "Fade configuration missing."}}
  end

  def get_all(config) do
    try do
      result =
        config
        |> Broker.get_all_request("api/bindings")
        |> ResultMapper.map_result(&DataMapper.map_data/1)

      {:ok, result}
    rescue
      _ ->
        {:error,
         %RabbitMqServerResponseError{message: "Something went wrong on the RabbitMQ server."}}
    end
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
