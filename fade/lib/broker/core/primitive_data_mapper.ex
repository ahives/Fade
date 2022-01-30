defmodule Fade.Broker.Core.PrimitiveDataMapper do
  alias Fade.Broker.Core.Types.Rate

  def to_atom(nil) do
    nil
  end

  def to_atom(data) do
    String.to_atom(data)
  end

  def map_rate(nil) do
    Rate.new(value: 0.0)
  end

  def map_rate(data) do
    Rate.new(value: data["rate"])
  end
end
