defmodule Fade.Diagnostic.Scanner.DiagnosticScanner do
  alias Fade.Diagnostic.Types.{DiagnosticProbe, DiagnosticScannerMetadata, ProbeResult}

  @callback get_metadata() :: DiagnosticScannerMetadata.t()
  @callback scan(probes :: list(DiagnosticProbe), snapshot :: any()) :: list(ProbeResult)
end
