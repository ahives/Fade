defmodule Fade.Diagnostic.Probes.ChannelLimitReachedProbe do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.Types.KnowledgeBaseArticle
  alias Fade.Diagnostic.IdentifierGeneration
  alias Fade.Snapshot.Types.ConnectionSnapshot

  @behaviour DiagnosticProbe

  def execute(nil, _snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    article =
      KnowledgeBaseArticle.new(
        reason: "Probe cannot execute properly without configuration.",
        remediation: nil
      )

    ProbeResult.not_applicable(nil, nil, metadata.id, metadata.name, component_type, article)
  end

  def execute(_config, nil) do
    metadata = get_metadata()
    component_type = get_component_type()

    article =
      KnowledgeBaseArticle.new(
        reason: "Probe cannot execute on empty data.",
        remediation: nil
      )

    ProbeResult.inconclusive(nil, nil, metadata.id, metadata.name, component_type, article)
  end

  @impl DiagnosticProbe
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: ConnectionSnapshot.t()) ::
          ProbeResult.t()
  def execute(_config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    channel_count = Enum.count(snapshot.channels)

    probe_data = [
      ProbeData.new(
        property_name: "channels.count",
        property_value: channel_count
      ),
      ProbeData.new(
        property_name: "open_channels_limit",
        property_value: snapshot.open_channels_limit
      )
    ]

    case compare_probe_readout(channel_count, snapshot.open_channels_limit) do
      true ->
        article =
          KnowledgeBaseArticle.new(
            reason: "Number of channels on connection exceeds the defined limit.",
            remediation:
              "Adjust application settings to reduce the number of connections to the RabbitMQ broker."
          )

        ProbeResult.unhealthy(
          snapshot.node_identifier,
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
            reason: "Number of channels on connection is less than defined limit."
          )

        ProbeResult.healthy(
          snapshot.node_identifier,
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
      "Fade.Diagnostic.Probes.ChannelLimitReachedProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Channel Limit Reached Probe",
      description: "Measures actual number of channels to the defined limit on connection."
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :connection

  @impl DiagnosticProbe
  def get_category, do: :throughput

  defp compare_probe_readout(lefthand_value, righthand_value),
    do: lefthand_value >= righthand_value
end
