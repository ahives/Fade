defmodule Fade.Diagnostic.Probes.ChannelThrottlingProbe do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.Types.KnowledgeBaseArticle
  alias Fade.Diagnostic.IdentifierGeneration
  alias Fade.Snapshot.Types.ChannelSnapshot

  @behaviour DiagnosticProbe

  def execute(_config, nil) do
    metadata = get_metadata()
    component_type = get_component_type()

    article = KnowledgeBaseArticle.new(reason: "Probe cannot execute on empty data.")
    ProbeResult.inconclusive(nil, nil, metadata.id, metadata.name, component_type, article)
  end

  @impl DiagnosticProbe
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: ChannelSnapshot.t()) ::
          ProbeResult.t()
  def execute(_config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

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
        article =
          KnowledgeBaseArticle.new(
            reason:
              "Unacknowledged messages on channel exceeds prefetch count causing the RabbitMQ broker to stop delivering messages to consumers.",
            remediation:
              "Acknowledged messages must be greater than or equal to the result of subtracting the number of unacknowledged messages from the prefetch count plus 1. Temporarily increase the number of consumers or prefetch count."
          )

        ProbeResult.unhealthy(
          snapshot.connection_identifier,
          snapshot.identifier,
          metadata.id,
          metadata.name,
          component_type,
          probe_data,
          article
        )

      false ->
        article =
          KnowledgeBaseArticle.new(
            reason: "Unacknowledged messages on channel is less than prefetch count."
          )

        ProbeResult.healthy(
          snapshot.connection_identifier,
          snapshot.identifier,
          metadata.id,
          metadata.name,
          component_type,
          probe_data,
          article
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
  def get_component_type, do: :channel

  @impl DiagnosticProbe
  def get_category, do: :throughput

  defp compare_probe_readout(lefthand_value, righthand_value),
    do: lefthand_value > righthand_value
end
