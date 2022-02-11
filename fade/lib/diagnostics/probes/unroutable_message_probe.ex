defmodule Fade.Diagnostic.Probes.UnroutableMessageProbe do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.Types.KnowledgeBaseArticle
  alias Fade.Diagnostic.IdentifierGeneration
  alias Fade.Snapshot.Types.BrokerQueueSnapshot

  @behaviour DiagnosticProbe

  def execute(_config, nil) do
    metadata = get_metadata()
    component_type = get_component_type()

    article = KnowledgeBaseArticle.new(reason: "Probe cannot execute on empty data.")
    ProbeResult.inconclusive(nil, nil, metadata.id, metadata.name, component_type, article)
  end

  @impl DiagnosticProbe
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: BrokerQueueSnapshot.t()) ::
          ProbeResult.t()
  def execute(_config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    probe_data = [
      ProbeData.new(
        property_name: "churn.not_routed.total",
        property_value: snapshot.churn.not_routed.total
      )
    ]

    if snapshot.churn.not_routed.total > 0 do
      article =
        KnowledgeBaseArticle.new(
          reason:
            "Some messages were published to an exchange but there is no queue bound to the exchange.",
          remediation:
            "Bind an appropriate queue to the exchange or stop publishing to the exchange."
        )

      ProbeResult.unhealthy(
        snapshot.cluster_name,
        nil,
        metadata.id,
        metadata.name,
        component_type,
        probe_data,
        article
      )
    else
      article =
        KnowledgeBaseArticle.new(
          reason: "No exchanges were published to that is not bound to a corresponding queue."
        )

      ProbeResult.healthy(
        snapshot.cluster_name,
        nil,
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
      "Fade.Diagnostic.Probes.UnroutableMessageProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Unroutable Message Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :exchange

  @impl DiagnosticProbe
  def get_category, do: :efficiency
end
