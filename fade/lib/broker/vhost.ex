defmodule Fade.Broker.VirtualHost do
  alias Fade.Broker
  alias Fade.Broker.VirtualHostDataMapper, as: DataMapper
  alias Fade.Broker.VirtualHostTypes.VirtualHostDefinition
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Core.ResultMapper
  alias Fade.Core.Sanitizer

  alias Fade.{
    ConfigurationMissingError,
    InvalidVirtualHostError,
    RabbitMqServerResponseError,
    VirtualHostMissingError
  }

  @doc """
  Returns information about each virtual host on the current RabbitMQ server.
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
        |> Broker.get_all_request("api/vhosts")
        |> ResultMapper.map_result(&DataMapper.map_data/1)

      {:ok, result}
    rescue
      _ ->
        {:error,
         %RabbitMqServerResponseError{message: "Something went wrong on the RabbitMQ server."}}
    end
  end

  @doc """
  Creates the specified virtual host on the current RabbitMQ server.
  """
  def create(config, vhost_name, description, tracing \\ false, tags \\ [])

  def create(nil, _vhost_name, _description, _tracing, _tags) do
    {:error, %ConfigurationMissingError{message: "Fade configuration missing."}}
  end

  def create(_config, nil, _description, _tracing, _tags) do
    {:error, %VirtualHostMissingError{message: "Virtual host not valid."}}
  end

  @spec create(
          config :: BrokerConfig.t(),
          vhost_name :: String.t(),
          description :: String.t(),
          tracing :: boolean(),
          tags :: list(String)
        ) ::
          {:ok, Result.t()}
          | {:error, RabbitMqServerResponseError.t()}
          | {:error, ConfigurationMissingError.t()}
          | {:error, VirtualHostMissingError.t()}
  def create(config, vhost_name, description, tracing, tags) do
    try do
      definition =
        VirtualHostDefinition.new(
          tracing: tracing,
          description: description,
          tags: tags |> Enum.join(", ")
        )

      sanitized_vhost = Sanitizer.to_sanitized_name(vhost_name)

      if sanitized_vhost == "" do
        {:error, %VirtualHostMissingError{message: "Virtual host missing."}}
      end

      result =
        config
        |> Broker.put_request("api/vhosts/#{sanitized_vhost}", definition)
        |> ResultMapper.map_result(&DataMapper.map_data/1)

      {:ok, result}
    rescue
      _ ->
        {:error,
         %RabbitMqServerResponseError{message: "Something went wrong on the RabbitMQ server."}}
    end
  end

  @doc """
  Deletes the specified RabbitMQ virtual host on the current server.
  """
  @spec delete(config :: BrokerConfig.t(), vhost_name :: String.t()) ::
          {:ok, Result.t()}
          | {:error, InvalidVirtualHostError.t()}
          | {:error, VirtualHostMissingError.t()}
          | {:error, ConfigurationMissingError.t()}
  def delete(nil, _vhost_name) do
    {:error, %ConfigurationMissingError{message: "Fade configuration missing."}}
  end

  def delete(_config, nil) do
    {:error, %VirtualHostMissingError{message: "Virtual host missing."}}
  end

  def delete(config, vhost_name) do
    try do
      sanitized_vhost = Sanitizer.to_sanitized_name(vhost_name)

      case sanitized_vhost do
        "" ->
          {:error, %VirtualHostMissingError{message: "Virtual host missing."}}

        "2%f" ->
          {:error, %InvalidVirtualHostError{message: "Virtual host not valid."}}

        _ ->
          result =
            config
            |> Broker.delete_request("api/vhosts/#{sanitized_vhost}")
            |> ResultMapper.map_result(&DataMapper.map_data/1)

          {:ok, result}
      end
    rescue
      _ ->
        {:error,
         %RabbitMqServerResponseError{message: "Something went wrong on the RabbitMQ server."}}
    end
  end
end
