defmodule Fade.Diagnostic.DiagnosticProbe do
  alias Fade.Diagnostic.Types.ProbeResult
  alias Fade.Diagnostic.Types.{DiagnosticsConfig, DiagnosticProbeMetadata}

  @callback get_category() :: atom()
  @callback get_component_type() :: atom()
  @callback get_metadata() :: DiagnosticProbeMetadata.t()
  @callback execute(config :: DiagnosticsConfig.t(), snapshot :: any) :: ProbeResult.t()
end
