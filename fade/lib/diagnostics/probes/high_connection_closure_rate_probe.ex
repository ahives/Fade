defmodule Fade.Diagnostic.Probes.HighConnectionClosureRateProbe do
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    DiagnosticsConfig,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.IdentifierGeneration
  alias Fade.Snapshot.Types.BrokerConnectivitySnapshot

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
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: BrokerConnectivitySnapshot.t()) ::
          ProbeResult.t()
  def execute(config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    probe_data = [
      ProbeData.new(
        property_name: "connections_closed.rate",
        property_value: snapshot.connections_closed.rate
      ),
      ProbeData.new(
        property_name: "high_connection_closure_rate_threshold",
        property_value: config.probes.high_connection_closure_rate_threshold
      )
    ]

    case compare_probe_readout(
           snapshot.connections_closed.rate,
           config.probes.high_connection_closure_rate_threshold
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
      "Fade.Diagnostic.Probes.HighConnectionClosureRateProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "High Connection Closure Rate Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :connection

  @impl DiagnosticProbe
  def get_category, do: :connectivity

  defp compare_probe_readout(snapshot_value, config_value), do: snapshot_value >= config_value
end
