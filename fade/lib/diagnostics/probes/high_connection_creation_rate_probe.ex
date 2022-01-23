defmodule Fade.Diagnostic.Probes.HighConnectionCreationRateProbe do
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.IdentifierGeneration

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
  def execute(config, snapshot) do
    data = snapshot.data
    metadata = get_metadata()
    component_type = get_component_type()

    probe_data = [
      ProbeData.new(
        property_name: "channels_created.rate",
        property_value: data.channels_created.rate
      ),
      ProbeData.new(
        property_name: "high_connection_creation_rate_threshold",
        property_value: config.probes.high_connection_creation_rate_threshold
      )
    ]

    case compare_probe_readout(
           data.channels_created.rate,
           config.probes.high_connection_creation_rate_threshold
         ) do
      true ->
        ProbeResult.warning(nil, nil, metadata.id, metadata.name, component_type, probe_data, nil)

      false ->
        ProbeResult.healthy(nil, nil, metadata.id, metadata.name, component_type, probe_data, nil)
    end
  end

  @impl DiagnosticProbe
  def get_metadata do
    id =
      "Fade.Diagnostic.Probes.HighConnectionCreationRateProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "High Connection Creation Rate Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type do
    :connection
  end

  @impl DiagnosticProbe
  def get_category do
    :connectivity
  end

  defp compare_probe_readout(snapshot_value, config_value) do
    snapshot_value >= config_value
  end
end
