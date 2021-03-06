defmodule Fade do
  alias FadeConfig
  alias Fade.Config.Types.{BrokerConfig, FadeConfig}

  def setup(%FadeConfig{} = config \\ %FadeConfig{}) do
    %BrokerConfig{
      base_url: config.base_url,
      headers: get_credentials(config.username, config.password) |> get_headers()
    }
  end

  defp get_headers(credentials) do
    [Authorization: "Basic #{credentials}", Accept: "application/json"]
  end

  defp get_credentials(username, password) do
    "#{username}:#{password}" |> Base.encode64()
  end
end
