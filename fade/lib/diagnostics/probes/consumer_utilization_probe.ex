defmodule Fade.Diagnostic.Probes.ConsumerUtilizationProbe do
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
      snapshot.connection_identifier,
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
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: QueueSnapshot.t()) ::
          ProbeResult.t()
  def execute(config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    probe_data = [
      ProbeData.new(
        property_name: "consumer_utilization",
        property_value: snapshot.consumer_utilization
      ),
      ProbeData.new(
        property_name: "consumer_utilization_threshold",
        property_value: config.probes.consumer_utilization_threshold
      )
    ]

    cond do
      is_warning(snapshot.consumer_utilization, config.probes.consumer_utilization_threshold) ->
        article =
          KnowledgeBaseArticle.new(
            reason:
              "The queue is not able to push messages to consumers efficiently due to network congestion and/or the prefetch limit on the consumer being set too low.",
            remediation:
              "Check your network connection between the consumer and RabbitMQ node and/or readjust the prefetch limit."
          )

        ProbeResult.warning(
          snapshot.node,
          snapshot.identifier,
          metadata.id,
          metadata.name,
          component_type,
          probe_data,
          article
        )

      is_unhealthy(snapshot.consumer_utilization, config.probes.consumer_utilization_threshold) ->
        article =
          KnowledgeBaseArticle.new(
            reason:
              "The queue is not able to push messages to consumers efficiently due to network congestion and/or the prefetch limit on the consumer being set too low.",
            remediation:
              "Check your network connection between the consumer and RabbitMQ node and/or readjust the prefetch limit."
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

      true ->
        article =
          KnowledgeBaseArticle.new(
            reason:
              "The queue is able to efficiently push messages to consumers as fast as possible without delay."
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
      "Fade.Diagnostic.Probes.ConsumerUtilizationProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Consumer Utilization Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :queue

  @impl DiagnosticProbe
  def get_category, do: :throughput

  defp is_warning(consumer_utilization, treshold),
    do: consumer_utilization >= treshold and consumer_utilization < 1.0 and treshold <= 1.0

  defp is_unhealthy(consumer_utilization, treshold),
    do: consumer_utilization < treshold and treshold <= 1.0
end
