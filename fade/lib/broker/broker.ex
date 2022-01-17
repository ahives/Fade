defmodule Fade.Broker do
  @moduledoc """
  Documentation for `Fade`.
  """

  use TypedStruct
  alias Fade.Types.Result
  alias Fade.Config.Types.BrokerConfig

  typedstruct module: ServerResponse do
    field(:url, String.t())
    field(:data, String.t())
    field(:status_code, integer())
    field(:has_faulted, boolean(), default: false)
    field(:error, atom())
  end

  @doc """
  Performs an HTTP GET operation on the RabbitMQ cluster.
  """
  def get_all_request(config = %BrokerConfig{}, url) do
    url = config.base_url <> url

    case HTTPoison.get(url, config.headers) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            %ServerResponse{
              url: url,
              data: response.body,
              status_code: response.status_code
            }

          _ ->
            %ServerResponse{
              url: url,
              data: response.body,
              has_faulted: true,
              status_code: response.status_code
            }
        end

      {:error, err} ->
        %ServerResponse{
          url: url,
          has_faulted: true,
          error: err.reason
        }
    end
  end

  def post_request(config = %BrokerConfig{}, url, value) do
    url = config.base_url <> url
    request = value |> Jason.encode!() |> IO.iodata_to_binary()

    case HTTPoison.post(url, request, config.headers) do
      {:ok, response} ->
        case response.status_code do
          200 ->
            %ServerResponse{
              url: url,
              data: response.body,
              status_code: response.status_code
            }

          _ ->
            %ServerResponse{
              url: url,
              data: response.body,
              has_faulted: true,
              status_code: response.status_code
            }
        end

      {:error, err} ->
        %ServerResponse{
          url: url,
          has_faulted: true,
          error: err.reason
        }
    end
  end
end
