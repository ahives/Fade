defmodule Fade.Broker.PolicyDataMapper do
  alias Fade.Broker.DataMapper
  alias Fade.Broker.PolicyTypes.PolicyInfo

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    data
    |> Stream.reject(&is_nil/1)
    |> Enum.map(fn policy ->
      PolicyInfo.new(
        virtual_host: policy["vhost"],
        name: policy["name"],
        pattern: policy["pattern"],
        applied_to: policy["apply-to"],
        definition: policy["definition"],
        priority: policy["priority"]
      )
    end)
  end
end
