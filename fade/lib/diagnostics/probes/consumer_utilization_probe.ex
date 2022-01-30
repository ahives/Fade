defmodule Fade.Diagnostic.Probes.ConsumerUtilizationProbe do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.IdentifierGeneration
  alias Fade.Snapshot.Types.QueueSnapshot

  @behaviour DiagnosticProbe

  def execute(nil, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    ProbeResult.not_applicable(
      snapshot.connection_identifier,
      snapshot.identifier,
      metadata.id,
      metadata.name,
      component_type,
      nil
    )
  end

  def execute(_config, nil) do
    metadata = get_metadata()
    component_type = get_component_type()

    ProbeResult.inconclusive(nil, nil, metadata.id, metadata.name, component_type, nil)
  end

  @impl DiagnosticProbe
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: QueueSnapshot.t()) ::
          ProbeResult.t()
  def execute(config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    probe_data = [
      ProbeData.new(
        property_name: "consumer_utilization",
        property_value: snapshot.consumer_utilization
      ),
      ProbeData.new(
        property_name: "consumer_utilization_threshold",
        property_value: config.probes.consumer_utilization_threshold
      )
    ]

    cond do
      is_warning(snapshot.consumer_utilization, config.probes.consumer_utilization_threshold) ->
        ProbeResult.warning(
          snapshot.node,
          snapshot.identifier,
          metadata.id,
          metadata.name,
          component_type,
          probe_data,
          nil
        )

      is_unhealthy(snapshot.consumer_utilization, config.probes.consumer_utilization_threshold) ->
        ProbeResult.unhealthy(
          snapshot.node,
          snapshot.identifier,
          metadata.id,
          metadata.name,
          component_type,
          probe_data,
          nil
        )

      true ->
        ProbeResult.healthy(
          snapshot.node,
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
      "Fade.Diagnostic.Probes.ConsumerUtilizationProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Consumer Utilization Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :connection

  @impl DiagnosticProbe
  def get_category, do: :throughput

  defp is_warning(consumer_utilization, treshold),
    do: consumer_utilization >= treshold and consumer_utilization < 1.0 and treshold <= 1.0

  defp is_unhealthy(consumer_utilization, treshold),
    do: consumer_utilization < treshold and treshold <= 1.0
end
