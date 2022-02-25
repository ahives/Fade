defmodule Fade.Broker.SystemOverview do
  require Logger

  alias Fade.Broker
  alias Fade.Broker.SystemOverviewDataMapper, as: DataMapper
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Core.ResultMapper
  alias Fade.{ConfigurationError, RabbitMqServerResponseError}

  @doc """
  Returns various bits of random information that describe the RabbitMQ system.
  """
  @spec get(config :: BrokerConfig.t()) ::
          {:ok, Result.t()}
          | {:error, ConfigurationError.t()}
          | {:error, RabbitMqServerResponseError.t()}
  def get(nil) do
    {:error, %ConfigurationError{message: "Fade configuration not valid."}}
  end

  def get(config) do
    try do
      result =
        config
        |> Broker.get_request("api/overview")
        |> ResultMapper.map_result(&DataMapper.map_data/1)

      {:ok, result}
    rescue
      _ ->
        {:error,
         %RabbitMqServerResponseError{message: "Something went wrong on the RabbitMQ server."}}
    end
  end
end
