defmodule Fade.Diagnostic.ProbeLocator do
  alias Fade.Diagnostic.DiagnosticProbe

  def find_probes do
    for {module, _} <- :code.all_loaded(),
        DiagnosticProbe in (module.module_info(:attributes)[:behaviour] || []) do
      module
    end
  end
end
