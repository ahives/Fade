defmodule Fade.Diagnostic.ScannerLocator do
  alias Fade.Diagnostic.Scanner.DiagnosticScanner

  def find_scanners do
    for {module, _} <- :code.all_loaded(),
        DiagnosticScanner in (module.module_info(:attributes)[:behaviour] || []) do
      module
    end
  end
end
