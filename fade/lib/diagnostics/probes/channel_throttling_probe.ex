defmodule Fade.Diagnostic.Probes.ChannelThrottlingProbe do
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
  def execute(_config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    channel_count = Enum.count(snapshot.channels)

    probe_data = [
      ProbeData.new(
        property_name: "unacknowledged_messages",
        property_value: snapshot.unacknowledged_messages
      ),
      ProbeData.new(
        property_name: "prefetch_count",
        property_value: snapshot.prefetch_count
      )
    ]

    case compare_probe_readout(snapshot.unacknowledged_messages, snapshot.prefetch_count) do
      true ->
        ProbeResult.unhealthy(
          snapshot.connection_identifier,
          snapshot.identifier,
          metadata.id,
          metadata.name,
          component_type,
          probe_data,
          nil
        )

      false ->
        ProbeResult.healthy(
          snapshot.connection_identifier,
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
      "Fade.Diagnostic.Probes.ChannelThrottlingProbe"
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

  defp compare_probe_readout(lefthand_value, righthand_value),
    do: lefthand_value > righthand_value
end
