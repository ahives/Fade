defmodule Fade.Diagnostic.Probes.NetworkPartitionProbe do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.Types.KnowledgeBaseArticle
  alias Fade.Diagnostic.IdentifierGeneration
  alias Fade.Snapshot.Types.NodeSnapshot

  @behaviour DiagnosticProbe

  def execute(nil, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    article =
      KnowledgeBaseArticle.new(reason: "Probe cannot execute properly without configuration.")

    ProbeResult.not_applicable(
      snapshot.cluster_identifier,
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
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: NodeSnapshot.t()) :: ProbeResult.t()
  def execute(_config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    probe_data = [
      ProbeData.new(
        property_name: "network_partitions",
        property_value: snapshot.network_partitions
      )
    ]

    if Enum.any?(snapshot.network_partitions) do
      article =
        KnowledgeBaseArticle.new(
          reason: "Network partitions detected between one or more nodes.",
          remediation:
            "Please consult the RabbitMQ documentation (https://www.rabbitmq.com/partitions.html) on which strategy best fits your scenario."
        )

      ProbeResult.unhealthy(
        snapshot.cluster_identifier,
        snapshot.identifier,
        metadata.id,
        metadata.name,
        component_type,
        probe_data,
        article
      )
    else
      article =
        KnowledgeBaseArticle.new(reason: "No network partitions were detected between nodes.")

      ProbeResult.healthy(
        snapshot.cluster_identifier,
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
      "Fade.Diagnostic.Probes.NetworkPartitionProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Network Partition Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :node

  @impl DiagnosticProbe
  def get_category, do: :connectivity
end
