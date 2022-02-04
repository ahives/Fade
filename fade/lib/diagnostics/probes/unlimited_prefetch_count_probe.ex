defmodule Fade.Diagnostic.Probes.UnlimitedPrefetchCountProbe do
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
        property_name: "prefetch_count",
        property_value: snapshot.prefetch_count
      )
    ]

    if snapshot.prefetch_count == 0 do
      article =
        KnowledgeBaseArticle.new(
          reason:
            "Prefetch count of 0 means unlimited prefetch count, which can translate into high CPU utilization.",
          remediation:
            "Set a prefetch count above zero based on how many consumer cores available."
        )

      ProbeResult.warning(
        snapshot.connection_identifier,
        snapshot.identifier,
        metadata.id,
        metadata.name,
        component_type,
        probe_data,
        article
      )
    else
      article =
        KnowledgeBaseArticle.new(
          reason: "Unable to determine whether prefetch count has an inappropriate value."
        )

      ProbeResult.inconclusive(
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
      "Fade.Diagnostic.Probes.UnlimitedPrefetchCountProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Unlimited Prefetch Count Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :channel

  @impl DiagnosticProbe
  def get_category, do: :throughput
end
