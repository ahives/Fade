defmodule Fade.Diagnostic.Types do
  use TypedStruct

  alias Fade.Diagnostic.DiagnosticProbe
  alias Fade.Diagnostic.Scanner.DiagnosticScanner

  typedstruct module: DiagnosticScannerProfile do
    field(:probes, list(DiagnosticProbe))
    field(:scanners, list(DiagnosticScanner))
    # field(:, )
    # field(:, )
    # field(:, )
  end

  typedstruct module: ProbeData do
    field(:property_name, String.t())
    field(:property_value, any())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  # typedstruct module: DiagnosticProbe do
  #   field(:metadata, DiagnosticProbeMetadata.t())

  #   field(
  #     :component_type,
  #     :connection
  #     | :channel
  #     | :queue
  #     | :node
  #     | :disk
  #     | :memory
  #     | :runtime
  #     | :operating_system
  #     | :exchange
  #     | :na
  #   )

  #   field(:category, :throughput | :connectivity | :memory | :fault_tolerance | :efficiency)

  #   def new(fields) do
  #     struct!(__MODULE__, fields)
  #   end
  # end

  typedstruct module: DiagnosticProbeMetadata do
    field(:id, String.t())
    field(:name, String.t())
    field(:description, String.t())

    def new(fields), do: struct!(__MODULE__, fields)
  end

  typedstruct module: DiagnosticScannerMetadata do
    field(:identifier, String.t())
  end
end
