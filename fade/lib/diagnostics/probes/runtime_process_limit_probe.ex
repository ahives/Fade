defmodule Fade.Diagnostic.Probes.RuntimeProcessLimitProbe do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.Types.KnowledgeBaseArticle
  alias Fade.Diagnostic.IdentifierGeneration
  alias Fade.Snapshot.Types.BrokerRuntimeSnapshot

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
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: BrokerRuntimeSnapshot.t()) ::
          ProbeResult.t()
  def execute(config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    calculated_threshold =
      compute_threshold(
        config.probes.runtime_process_usage_threshold_coefficient,
        snapshot.processes.limit.total
      )

    probe_data = [
      ProbeData.new(
        property_name: "processes.limit.total",
        property_value: snapshot.processes.limit.total
      ),
      ProbeData.new(
        property_name: "processes.limit.used",
        property_value: snapshot.processes.limit.used
      ),
      ProbeData.new(
        property_name: "runtime_process_usage_threshold_coefficient",
        property_value: config.probes.runtime_process_usage_threshold_coefficient
      ),
      ProbeData.new(
        property_name: "calculated_threshold",
        property_value: calculated_threshold
      )
    ]

    cond do
      is_unhealthy(snapshot.processes.limit.used, snapshot.processes.limit) ->
        article =
          KnowledgeBaseArticle.new(
            reason:
              "The queue is not able to push messages to consumers efficiently due to network congestion and/or the prefetch limit on the consumer being set too low.",
            remediation:
              "Check your network connection between the consumer and RabbitMQ node and/or readjust the prefetch limit."
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

      is_warning(snapshot.processes.limit.used, snapshot.processes.limit, calculated_threshold) ->
        article =
          KnowledgeBaseArticle.new(
            reason:
              "The queue is not able to push messages to consumers efficiently due to network congestion and/or the prefetch limit on the consumer being set too low.",
            remediation:
              "Check your network connection between the consumer and RabbitMQ node and/or readjust the prefetch limit."
          )

        ProbeResult.warning(
          snapshot.cluster_identifier,
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
      "Fade.Diagnostic.Probes.RuntimeProcessLimitProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Runtime Process Limit Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :connection

  @impl DiagnosticProbe
  def get_category, do: :throughput

  defp is_warning(processes_used, processes_limit, treshold),
    do: processes_used >= treshold and treshold <= processes_limit

  defp is_unhealthy(processes_used, processes_limit),
    do: processes_used >= processes_limit

  defp compute_threshold(threshold_coefficient, total_messages_incoming) do
    case threshold_coefficient >= 1 do
      true ->
        total_messages_incoming

      false ->
        :math.ceil(total_messages_incoming * threshold_coefficient)
    end
  end
end
