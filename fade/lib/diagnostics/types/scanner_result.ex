defmodule Fade.Diagnostic.Types.ScannerResult do
  use TypedStruct

  alias Fade.Diagnostic.Types.ProbeResult

  typedstruct do
    field(:id, String.t())
    field(:scanner_id, String.t())
    field(:probe_results, list(ProbeResult))
    field(:timestamp, DateTime.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end
end
