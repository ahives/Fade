defmodule Fade.Diagnostic.IdentifierGeneration do
  def get_identifier(type) do
    :crypto.hash(:md5, type) |> Base.encode64(case: :lower)
  end
end
