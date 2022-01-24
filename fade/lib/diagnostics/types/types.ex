defmodule Fade.Diagnostic.Types do
  use TypedStruct

  typedstruct module: DiagnosticProbeMetadata do
    field(:id, String.t())
    field(:name, String.t())
    field(:description, String.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: DiagnosticScannerMetadata do
    field(:identifier, String.t())
  end
end
