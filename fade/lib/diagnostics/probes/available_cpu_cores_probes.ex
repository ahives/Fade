defmodule Fade.Diagnostic.Probes.AvailableCpuCoresProbe do
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
        property_name: "available_cores_detected",
        property_value: snapshot.available_cores_detected
      )
    ]

    case snapshot.available_cores_detected <= 0 do
      true ->
        article =
          KnowledgeBaseArticle.new(
            reason:
              "Could not detect any CPU cores or none are available to the RabbitMQ broker.",
            remediation: "Add more CPU cores to the RabbitMQ node."
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

      false ->
        article =
          KnowledgeBaseArticle.new(
            reason: "Detected at least 1 CPU core available to the RabbitMQ broker."
          )

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
      "Fade.Diagnostic.Probes.AvailableCpuCoresProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Available CPU Cores Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :node

  @impl DiagnosticProbe
  def get_category, do: :throughput
end
