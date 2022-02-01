defmodule Fade.Diagnostic.Probes.FileDescriptorThrottlingProbe do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Types.{
    DiagnosticProbeMetadata,
    ProbeData,
    ProbeResult
  }

  alias Fade.Diagnostic.Types.KnowledgeBaseArticle
  alias Fade.Diagnostic.IdentifierGeneration
  alias Fade.Snapshot.Types.OperatingSystemSnapshot

  @behaviour DiagnosticProbe

  def execute(nil, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    article =
      KnowledgeBaseArticle.new(reason: "Probe cannot execute properly without configuration.")

    ProbeResult.not_applicable(
      snapshot.node_identifier,
      snapshot.process_id,
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
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: OperatingSystemSnapshot.t()) ::
          ProbeResult.t()
  def execute(config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    calculated_threshold =
      compute_threshold(
        config.probes.file_descriptor_usage_threshold_coefficient,
        snapshot.file_descriptors.available
      )

    probe_data = [
      ProbeData.new(
        property_name: "file_descriptors.used",
        property_value: snapshot.file_descriptors.used
      ),
      ProbeData.new(
        property_name: "file_descriptors.available",
        property_value: snapshot.file_descriptors.available
      ),
      ProbeData.new(
        property_name: "file_descriptor_usage_threshold_coefficient",
        property_value: config.probes.file_descriptor_usage_threshold_coefficient
      ),
      ProbeData.new(
        property_name: "calculated_threshold",
        property_value: calculated_threshold
      )
    ]

    cond do
      is_healthy(
        snapshot.file_descriptors.used,
        snapshot.file_descriptors.available,
        calculated_threshold
      ) ->
        article =
          KnowledgeBaseArticle.new(
            reason: "The number of file handles currently in use is below the max number allowed."
          )

        ProbeResult.healthy(
          snapshot.node_identifier,
          snapshot.process_id,
          metadata.id,
          metadata.name,
          component_type,
          probe_data,
          article
        )

      is_unhealthy(snapshot.file_descriptors.used, snapshot.file_descriptors.available) ->
        article =
          KnowledgeBaseArticle.new(
            reason:
              "The max limit of available file descriptors that are in use has been reached. This will prevent applications from being able to open more connections to the broker and the RabbitMQ node from opening any files in support of current transactions.",
            remediation:
              "Increase the max number of allowed file handles (see https://www.rabbitmq.com/networking.html#open-file-handle-limit)."
          )

        ProbeResult.unhealthy(
          snapshot.node_identifier,
          snapshot.process_id,
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
              "Used file descriptors are less than the amount available but greater than the calculated threshold.",
            remediation:
              "Increase the max number of allowed file handles (see https://www.rabbitmq.com/networking.html#open-file-handle-limit)."
          )

        ProbeResult.warning(
          snapshot.node_identifier,
          snapshot.process_id,
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
      "Fade.Diagnostic.Probes.FileDescriptorThrottlingProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "File Descriptor Throttling Probe",
      description: ""
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :operating_system

  @impl DiagnosticProbe
  def get_category, do: :throughput

  defp is_healthy(file_descriptors_used, file_descriptors_available, threshold),
    do: file_descriptors_used < threshold and threshold < file_descriptors_available

  defp is_unhealthy(file_descriptors_used, file_descriptors_available),
    do: file_descriptors_used == file_descriptors_available

  defp compute_threshold(threshold_coefficient, file_descriptors_available) do
    case threshold_coefficient >= 1 do
      true ->
        file_descriptors_available

      false ->
        :math.ceil(file_descriptors_available * threshold_coefficient)
    end
  end
end
