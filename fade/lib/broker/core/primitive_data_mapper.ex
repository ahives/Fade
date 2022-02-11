defmodule Fade.Broker.Core.PrimitiveDataMapper do
  alias Fade.Broker.Core.Types.Rate

  def to_atom(nil), do: nil

  def to_atom(data), do: String.to_atom(data)

  def map_rate(nil), do: Rate.new(value: 0.0)

  def map_rate(data), do: Rate.new(value: data["rate"])

  def get_value(nil), do: 0

  def get_value(data), do: data.value
end
