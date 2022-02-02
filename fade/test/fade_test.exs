defmodule FadeTest do
  use ExUnit.Case

  alias Fade
  alias Fade.Broker.Queues
  alias Fade.Config.Types.FadeConfig

  test "Verify_can_get_all_queues" do
    result =
      get_config
      |> Queues.get_all()

    assert not is_nil(result)
    assert not is_nil(result.data)
    assert is_list(result.data)

    IO.inspect(result.data |> Enum.at(5))
  end

  test "Verify" do
    system_overview_data = SystemOverviewData.get()
  end

  defp get_config do
    %Fade.Config.Types.FadeConfig{
      base_url: "http://localhost:15672/",
      username: "guest",
      password: "guest"
    }
    |> Fade.setup()
  end
end
