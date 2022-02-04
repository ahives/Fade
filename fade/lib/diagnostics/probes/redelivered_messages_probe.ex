defmodule Fade.Diagnostic.Probes.RedeliveredMessagesProbe do
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

  def execute(config, nil) do
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

    calculated_threshold =
      compute_threshold(
        config.probes.message_redelivery_threshold_coefficient,
        snapshot.messages.incoming.total
      )

    probe_data = [
      ProbeData.new(
        property_name: "messages.incoming.total",
        property_value: snapshot.messages.incoming.total
      ),
      ProbeData.new(
        property_name: "messages.redelivered.total",
        property_value: snapshot.messages.redelivered.total
      ),
      ProbeData.new(
        property_name: "message_redelivery_threshold_coefficient",
        property_value: config.probes.message_redelivery_threshold_coefficient
      ),
      ProbeData.new(
        property_name: "calculated_threshold",
        property_value: calculated_threshold
      )
    ]

    cond do
      is_warning(
        snapshot.messages.redelivered.total,
        snapshot.messages.incoming.total,
        calculated_threshold
      ) ->
        article =
          KnowledgeBaseArticle.new(
            reason:
              "The number of redelivered messages is less than or equal to the number of incoming messages and greater than or equal to the number of incoming messages multiplied a configurable coefficient."
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

      is_unhealthy(
        snapshot.messages.redelivered.total,
        snapshot.messages.incoming.total
      ) ->
        article =
          KnowledgeBaseArticle.new(
            reason:
              "The number of redelivered messages is less than or equal to the number of incoming messages."
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
        article = KnowledgeBaseArticle.new(reason: "")

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
      name: "Redelivered Messages Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :connection

  @impl DiagnosticProbe
  def get_category, do: :throughput

  defp is_warning(redelivered_total, incoming_total, treshold),
    do:
      redelivered_total >= treshold and redelivered_total < incoming_total and
        treshold < incoming_total

  defp is_unhealthy(redelivered_total, incoming_total),
    do: redelivered_total >= incoming_total

  defp compute_threshold(threshold_coefficient, total_messages_incoming) do
    case threshold_coefficient >= 1 do
      true ->
        total_messages_incoming

      false ->
        :math.ceil(total_messages_incoming * threshold_coefficient)
    end
  end
end
