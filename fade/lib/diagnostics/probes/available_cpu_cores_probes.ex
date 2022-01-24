defmodule Fade.Diagnostic.Probes.AvailableCpuCoresProbe do
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    DiagnosticsConfig,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.IdentifierGeneration
  alias Fade.Diagnostic.Types.ProbeResult

  @behaviour DiagnosticProbe

  def execute(nil, _snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    ProbeResult.not_applicable(nil, nil, metadata.id, metadata.name, component_type, nil)
  end

  def execute(_config, nil) do
    metadata = get_metadata()
    component_type = get_component_type()

    ProbeResult.inconclusive(nil, nil, metadata.id, metadata.name, component_type, nil)
  end

  @impl DiagnosticProbe
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: NodeSnapshot.t()) :: ProbeResult.t()
  def execute(_config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    probe_data = [
      ProbeData.new(
        property_name: "available_cores_detected",
        property_value: snapshot.available_cores_detected
      )
    ]

    case snapshot.available_cores_detected <= 0 do
      true ->
        ProbeResult.unhealthy(
          snapshot.cluster_identifier,
          snapshot.identifier,
          metadata.id,
          metadata.name,
          component_type,
          nil
        )

      false ->
        ProbeResult.healthy(
          snapshot.cluster_identifier,
          snapshot.identifier,
          metadata.id,
          metadata.name,
          component_type,
          probe_data,
          nil
        )
    end
  end

  @impl DiagnosticProbe
  def get_metadata do
    id =
      "Fade.Diagnostic.Probes.AvailableCpuCoresProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Available CPU Cores Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :connection

  @impl DiagnosticProbe
  def get_category, do: :connectivity
end
