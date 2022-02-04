defmodule Fade.Diagnostic.Probes.QueueGrowthProbe do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.Types.KnowledgeBaseArticle
  alias Fade.Diagnostic.IdentifierGeneration
  alias Fade.Snapshot.Types.QueueSnapshot

  @behaviour DiagnosticProbe

  def execute(nil, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    article =
      KnowledgeBaseArticle.new(reason: "Probe cannot execute properly without configuration.")

    ProbeResult.not_applicable(
      snapshot.node,
      snapshot.identifier,
      metadata.id,
      metadata.name,
      component_type,
      article
    )
  end

  def execute(_config, nil) do
    metadata = get_metadata()
    component_type = get_component_type()

    article = KnowledgeBaseArticle.new(reason: "Probe cannot execute on empty data.")
    ProbeResult.inconclusive(nil, nil, metadata.id, metadata.name, component_type, article)
  end

  @impl DiagnosticProbe
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: QueueSnapshot.t()) :: ProbeResult.t()
  def execute(_config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    probe_data = [
      ProbeData.new(
        property_name: "messages.incoming.rate",
        property_value: snapshot.messages.incoming.rate
      ),
      ProbeData.new(
        property_name: "messages.acknowledged.rate",
        property_value: snapshot.messages.acknowledged.rate
      )
    ]

    if snapshot.messages.incoming.rate > snapshot.messages.acknowledged.rate do
      article =
        KnowledgeBaseArticle.new(
          reason:
            "Messages are being published to the queue at a higher rate than are being consumed and acknowledged by consumers.",
          remediation: "Adjust application settings to spawn more consumers."
        )

      ProbeResult.unhealthy(
        snapshot.node,
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
          reason:
            "Messages are being consumed and acknowledged at a higher rate than are being published to the queue."
        )

      ProbeResult.healthy(
        snapshot.node,
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
      "Fade.Diagnostic.Probes.QueueGrowthProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Queue Growth Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :queue

  @impl DiagnosticProbe
  def get_category, do: :throughput
end
