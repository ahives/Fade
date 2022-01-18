defmodule Fade.Broker.Core.PrimitiveDataMapper do
  alias Fade.Broker.Core.Types.Rate

  def map_rate(data) do
    Rate.new(value: data["rate"])
  end

  def to_atom(data) do
    if is_nil(data) do
      nil
    else
      String.to_atom(data)
    end
  end
end
