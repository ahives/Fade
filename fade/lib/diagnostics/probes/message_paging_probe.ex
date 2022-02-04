defmodule Fade.Diagnostic.Probes.MessagePagingProbe do
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
        property_name: "memory.paged_out.total",
        property_value: snapshot.memory.paged_out.total
      )
    ]

    if snapshot.memory.paged_out.total > 0 do
      article =
        KnowledgeBaseArticle.new(
          reason:
            "Broker is nearing RAM high watermark and has paged messages to disk to prevent publishers from being blocked.",
          remediation:
            "Increase the amount of RAM available to the broker and configure the broker with the new watermark value."
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
        KnowledgeBaseArticle.new(reason: "RAM used by broker is less than high watermark.")

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
      "Fade.Diagnostic.Probes.MessagePagingProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Message Paging Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :queue

  @impl DiagnosticProbe
  def get_category, do: :memory
end
