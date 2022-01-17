defmodule Fade.Broker.Core.DataMappings do
  alias Fade.Broker.Core.Types.Rate

  def map_rate(data) do
    Rate.new(value: data["rate"])
  end
end
