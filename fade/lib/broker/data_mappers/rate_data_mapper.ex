defmodule Fade.Broker.RateDataMapper do
  alias Fade.Broker.CommonTypes.Rate

  def map_rate(nil), do: Rate.new(value: 0.0)

  def map_rate(data), do: Rate.new(value: data["rate"])

  def get_rate_value(nil), do: 0

  def get_rate_value(data), do: data.value
end
