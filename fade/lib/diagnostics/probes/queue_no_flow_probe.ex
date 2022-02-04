defmodule Fade.Diagnostic.Probes.QueueNoFlowProbe do
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
        property_name: "messages.incoming.total",
        property_value: snapshot.messages.incoming.total
      )
    ]

    if snapshot.messages.incoming.total = 0 do
      article =
        KnowledgeBaseArticle.new(
          reason: "There are no messages being published to the specified queue."
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
          reason: "One or more messages have being published to the specified queue."
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
      "Fade.Diagnostic.Probes.QueueNoFlowProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Queue No Flow Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :queue

  @impl DiagnosticProbe
  def get_category, do: :throughput
end
