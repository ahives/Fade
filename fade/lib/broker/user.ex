defmodule Fade.Broker.User do
  alias Fade.Broker
  alias Fade.Broker.UserDataMapper, as: DataMapper
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Core.ResultMapper

  alias Fade.{
    ConfigurationMissingError,
    RabbitMqServerResponseError
  }

  @doc """
  Returns information about all users on the current RabbitMQ server.
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
        |> Broker.get_all_request("api/users")
        |> ResultMapper.map_result(&DataMapper.map_data/1)

      {:ok, result}
    rescue
      _ ->
        {:error,
         %RabbitMqServerResponseError{message: "Something went wrong on the RabbitMQ server."}}
    end
  end
end
