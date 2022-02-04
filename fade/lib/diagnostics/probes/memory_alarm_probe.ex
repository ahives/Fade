defmodule Fade.Diagnostic.Probes.MemoryAlarmProbe do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.Types.KnowledgeBaseArticle
  alias Fade.Diagnostic.IdentifierGeneration
  alias Fade.Snapshot.Types.MemorySnapshot

  @behaviour DiagnosticProbe

  def execute(nil, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    article =
      KnowledgeBaseArticle.new(reason: "Probe cannot execute properly without configuration.")

    ProbeResult.not_applicable(
      snapshot.node_identifier,
      nil,
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
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: MemorySnapshot.t()) ::
          ProbeResult.t()
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
        property_name: "used",
        property_value: snapshot.used
      )
    ]

    case snapshot.alarm_in_effect do
      true ->
        article =
          KnowledgeBaseArticle.new(
            reason:
              "The threshold was reached for how much RAM can be used by the RabbitMQ Broker.",
            remediation:
              "Do one or a combination of the following:\n1) Increase the threshold of available RAM by changing either the vm_memory_high_watermark.absolute or vm_memory_high_watermark.relative broker configuration values.\n2) Spawn more consumers so that messages are not held in RAM for long periods.\n3) Increase the cluster hardware specification by adding more RAM."
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
            reason:
              "The amount of RAM used is less than the current threshold (i.e. vm_memory_high_watermark.absolute or vm_memory_high_watermark.relative)."
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
      "Fade.Diagnostic.Probes.MemoryAlarmProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Memory Alarm Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :memory

  @impl DiagnosticProbe
  def get_category, do: :throughput
end
