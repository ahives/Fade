defmodule Fade.Diagnostic.Scanner do
  alias Fade.Diagnostic.Types.ScannerResult
  @spec scan(snapshot :: any) :: ScannerResult.t()
  def scan(_snapshot) do
    :not_implemented
  end
end
