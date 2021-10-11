defmodule Fade do
  @moduledoc """
  Documentation for `Fade`.
  """

  alias Fade.Types.{BrokerConfig, Result}

  @doc """
  Performs an HTTP GET operation on the RabbitMQ cluster.
  """
  def get_all_request(%BrokerConfig{} = config, url) do
    url = config.base_url <> url

    case HTTPoison.get(url, config.headers) do
      {:ok, response} ->
        case response.status_code do
          200 -> Result.get_successful_response(response.body, url)
          _ -> Result.get_faulted_response(response.status_code, url)
        end

      {:error, reason} ->
        Result.get_faulted_response_with_reason(reason, url)
    end
  end
end
