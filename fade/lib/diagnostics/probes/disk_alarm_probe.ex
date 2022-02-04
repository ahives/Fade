defmodule Fade.Diagnostic.Probes.DiskAlarmProbe do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.Types.KnowledgeBaseArticle
  alias Fade.Diagnostic.IdentifierGeneration
  alias Fade.Snapshot.Types.DiskSnapshot

  @behaviour DiagnosticProbe

  def execute(_config, nil) do
    metadata = get_metadata()
    component_type = get_component_type()

    article = KnowledgeBaseArticle.new(reason: "Probe cannot execute on empty data.")
    ProbeResult.inconclusive(nil, nil, metadata.id, metadata.name, component_type, article)
  end

  @impl DiagnosticProbe
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: DiskSnapshot.t()) :: ProbeResult.t()
  def execute(_config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    probe_data = [
      ProbeData.new(
        property_name: "alarm_in_effect",
        property_value: snapshot.alarm_in_effect
      ),
      ProbeData.new(
        property_name: "limit",
        property_value: snapshot.limit
      ),
      ProbeData.new(
        property_name: "capacity.available",
        property_value: snapshot.capacity.available
      )
    ]

    case snapshot.alarm_in_effect do
      true ->
        article =
          KnowledgeBaseArticle.new(
            reason: "The node has reached the threshold for usable disk space.",
            remediation:
              "Increase message consumption throughput by spawning more consumers and/or increase disk size to keep up with incoming demand."
          )

        ProbeResult.unhealthy(
          snapshot.node_identifier,
          nil,
          metadata.id,
          metadata.name,
          component_type,
          probe_data,
          article
        )

      false ->
        article =
          KnowledgeBaseArticle.new(
            reason: "The node is under the allowable threshold for usable disk space."
          )

        ProbeResult.healthy(
          snapshot.node_identifier,
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
      "Fade.Diagnostic.Probes.DiskAlarmProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Disk Alarm Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :disk

  @impl DiagnosticProbe
  def get_category, do: :throughput
end
