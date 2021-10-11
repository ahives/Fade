defmodule Fade.Bindings do
  alias Fade.Types.BrokerConfig

  @doc """
  Returns all bindings on the current RabbitMQ node.
  """
  def get_all(%BrokerConfig{} = config) do
    url = "api/bindings"

    Fade.get_all_request(config, url)
  end
end
