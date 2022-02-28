defmodule Fade.Broker.VirtualHostLimit do
  alias Fade.Broker
  alias Fade.Broker.VirtualHostLimitDataMapper, as: DataMapper
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Core.ResultMapper

  alias Fade.{
    ConfigurationMissingError,
    RabbitMqServerResponseError
  }

  @doc """
  Returns limit information about each virtual host on the current RabbitMQ server.
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
        |> Broker.get_all_request("api/vhost-limits")
        |> ResultMapper.map_result(&DataMapper.map_data/1)

      {:ok, result}
    rescue
      _ ->
        {:error,
         %RabbitMqServerResponseError{message: "Something went wrong on the RabbitMQ server."}}
    end
  end
end
