defmodule Fade.Broker.Exchanges do
  alias Fade.Broker
  alias Fade.Broker.Core.DataMappings
  alias Fade.Broker.Exchange.Types.ExchangeInfo
  alias Fade.Broker.ServerResponse
  alias Fade.Config.Types.BrokerConfig
  alias Fade.Types.Result

  @doc """
  Returns all exchanges on the current RabbitMQ node.
  """
  def get_all(config = %BrokerConfig{}) when not is_nil(config) do
    config
    |> Broker.get_all_request("api/exchanges")
    |> map_result()
  end

  defp map_result(server_response = %ServerResponse{}) do
    case Jason.decode(server_response.data) do
      {:ok, decoded_object} ->
        decoded_object
        |> map_exchanges()
        |> Result.get_successful_response(server_response.data, server_response.url)

      {:error, _} ->
        Result.get_faulted_response_with_reason(
          "Error decoding the returned object.",
          server_response.url
        )
    end
  end

  defp map_exchanges(exchanges) do
    exchanges
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn exchange ->
      ExchangeInfo.new(
        name: exchange["name"],
        vhost: exchange["vhost"],
        user_who_performed_action: exchange["user_who_performed_action"],
        routing_type: DataMappings.to_atom(exchange["routing_type"]),
        durable: exchange["durable"],
        auto_delete: exchange["auto_delete"],
        internal: exchange["internal"],
        arguments: exchange["arguments"]
      )
    end)
  end
end
