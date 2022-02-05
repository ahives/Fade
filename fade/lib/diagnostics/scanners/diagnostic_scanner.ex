defmodule Fade.Diagnostic.Scanner.DiagnosticScanner do
  alias Fade.Diagnostic.DiagnosticProbe
  alias Fade.Diagnostic.Types.{DiagnosticScannerMetadata, ProbeResult}
  alias Fade.DiagnosticScannerError

  @callback get_metadata() :: DiagnosticScannerMetadata.t()
  @callback scan(
              config :: DiagnosticsConfig.t(),
              probes :: list(DiagnosticProbe),
              snapshot :: any()
            ) :: {:ok, list(ProbeResult)} | {:error, DiagnosticScannerError.t()}
end
