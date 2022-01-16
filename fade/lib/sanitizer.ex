defmodule Fade.Sanitizer do
  def to_sanitized_name(value) do
    if value == "/", do: String.replace(value, "/", "%2f"), else: value
  end
end
