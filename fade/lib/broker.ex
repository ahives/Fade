defmodule Fade.Broker do
  use TypedStruct
  alias Fade.{Bindings}
  alias Fade.Types.{BrokerConfig, FadeConfig}

  @doc """
  Performs an HTTP GET operation on the RabbitMQ cluster.
  """
  # def init(%FadeConfig{} = config \\ %FadeConfig{}) do
  #   %BrokerConfig{
  #     base_url: config.base_url,
  #     headers: get_credentials(config.username, config.password) |> get_headers()
  #   }
  # end

  @doc """
  Returns all bindings on the current RabbitMQ node.
  """
  def get_all_bindings(%BrokerConfig{} = config) do
    Bindings.get_all(config)
  end

  # defp get_headers(credentials) do
  #   [Authorization: "Basic #{credentials}", Accept: "application/json"]
  # end

  # defp get_credentials(username, password) do
  #   "#{username}:#{password}" |> Base.encode64()
  # end
end
