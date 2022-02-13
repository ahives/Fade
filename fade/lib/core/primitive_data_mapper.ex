defmodule Fade.Core.PrimitiveDataMapper do
  def to_atom(nil), do: nil

  def to_atom(data), do: String.to_atom(data)

  def get_value(nil), do: 0

  def get_value(data), do: data
end
