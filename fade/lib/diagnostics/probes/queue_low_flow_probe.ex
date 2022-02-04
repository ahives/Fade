defmodule Fade.Diagnostic.Probes.QueueLowFlowProbe do
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
  def execute(config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    probe_data = [
      ProbeData.new(
        property_name: "messages.incoming.total",
        property_value: snapshot.messages.incoming.total
      ),
      ProbeData.new(
        property_name: "queue_low_flow_threshold",
        property_value: config.probes.queue_low_flow_threshold
      )
    ]

    if snapshot.messages.incoming.total <= config.probes.queue_low_flow_threshold do
      article =
        KnowledgeBaseArticle.new(
          reason:
            "Messages being published to broker is less or equal to the specified threshold."
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
          reason: "Messages being published to broker is greater than specified threshold."
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
      "Fade.Diagnostic.Probes.QueueLowFlowProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Queue Low Flow Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :queue

  @impl DiagnosticProbe
  def get_category, do: :throughput
end
