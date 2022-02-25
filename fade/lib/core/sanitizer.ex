defmodule Fade.Core.Sanitizer do
  def to_sanitized_name(value) do
    if is_nil(value) or value |> String.trim() == "" do
      ""
    end

    if value == "/", do: value |> String.replace("/", "%2f"), else: value
  end
end
