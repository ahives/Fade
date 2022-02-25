defmodule Fade.Broker.Queue do
  require Logger

  alias Fade.Broker
  alias Fade.Broker.QueueDataMapper, as: DataMapper
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Core.ResultMapper
  alias Fade.{ConfigurationError, RabbitMqServerResponseError}

  @doc """
  Returns all queues on the current RabbitMQ node.
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
        |> Broker.get_all_request("api/queues")
        |> ResultMapper.map_result(&DataMapper.map_data/1)

      {:ok, result}
    rescue
      _ ->
        {:error,
         %RabbitMqServerResponseError{message: "Something went wrong on the RabbitMQ server."}}
    end
  end
end
