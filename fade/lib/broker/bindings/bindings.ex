defmodule Fade.Broker.Bindings do
  use TypedStruct
  require Logger

  alias Fade.Sanitizer
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Broker.Bindings.Types.{BindingCriteria, BindingDefinition, BindingInfo}
  alias Fade.Broker
  alias Fade.Broker.ServerResponse
  alias Fade.Types.Result

  @doc """
  Returns all bindings on the current RabbitMQ node.
  """
  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/bindings")
    |> map_result()
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

  defp map_result(server_response = %ServerResponse{}) do
    case Jason.decode(server_response.data) do
      {:ok, decoded_object} ->
        decoded_object
        |> map_bindings
        |> Result.get_successful_response(server_response.data, server_response.url)

      {:error, _} ->
        Result.get_faulted_response_with_reason(
          "Error decoding the returned object.",
          server_response.url
        )
    end
  end

  defp map_bindings(bindings) do
    bindings
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn binding ->
      BindingInfo.new(
        source: binding["source"],
        vhost: binding["vhost"],
        destination: binding["destination"],
        destination_type: binding["destination_type"],
        routing_key: binding["routing_key"],
        arguments: binding["arguments"],
        properties_key: binding["properties_key"]
      )
    end)
  end
end
