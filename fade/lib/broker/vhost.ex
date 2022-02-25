defmodule Fade.Broker.VirtualHost do
  alias Fade.Broker
  alias Fade.Broker.VirtualHostDataMapper, as: DataMapper
  alias Fade.Broker.VirtualHostTypes.VirtualHostDefinition
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Core.ResultMapper
  alias Fade.Core.Sanitizer
  alias Fade.{ConfigurationError, RabbitMqServerResponseError}

  @doc """
  Returns information about each virtual host on the current RabbitMQ server.
  """
  @spec get_all(config :: BrokerConfig.t()) ::
          {:ok, Result.t()}
          | {:error, ConfigurationError.t()}
          | {:error, RabbitMqServerResponseError.t()}
  def get_all(nil) do
    {:error, %ConfigurationError{message: "Fade configuration not valid."}}
  end

  def get_all(config) do
    try do
      result =
        config
        |> Broker.get_all_request("api/vhosts")
        |> ResultMapper.map_result(&DataMapper.map_data/1)

      {:ok, result}
    rescue
      _ ->
        {:error,
         %RabbitMqServerResponseError{message: "Something went wrong on the RabbitMQ server."}}
    end
  end

  @spec create(config :: BrokerConfig.t(), name :: String.t(), description :: String.t()) ::
          Fade.Broker.ServerResponse.t()
  def create(config = %BrokerConfig{}, name, description) do
    definition =
      VirtualHostDefinition.new(tracing: false, description: description, tags: "administration")

    sanitized_vhost = Sanitizer.to_sanitized_name(name)

    config
    |> Broker.put_request("api/vhosts/#{sanitized_vhost}", definition)
  end
end
