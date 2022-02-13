defmodule Fade.Core.ResultMapper do
  alias Fade.Broker.ServerResponse
  alias Fade.Types.Result

  def map_result(server_response = %ServerResponse{}, mapper) do
    case Jason.decode(server_response.data) do
      {:ok, deserialized_object} ->
        deserialized_object
        |> mapper.()
        |> Result.get_successful_response(server_response.data, server_response.url)

      {:error, _} ->
        Result.get_faulted_response_with_reason(
          "Error decoding the returned object.",
          server_response.url
        )
    end
  end
end
