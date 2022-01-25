defmodule Fade.Diagnostic.Probes.ConsumerUtilizationProbe do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.IdentifierGeneration
  alias Fade.Snapshot.Types.ChannelSnapshot

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
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: ChannelSnapshot.t()) ::
          ProbeResult.t()
  def execute(config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    channel_count = Enum.count(snapshot.channels)

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

      _ ->
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
      "Fade.Diagnostic.Probes.ChannelLimitReachedProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Channel Throttling Probe",
      description:
        "Monitors connections to the RabbitMQ broker to determine whether channels are being throttled."
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
