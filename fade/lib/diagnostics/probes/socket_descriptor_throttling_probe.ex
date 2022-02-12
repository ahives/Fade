defmodule Fade.Diagnostic.Probes.SocketDescriptorThrottlingProbe do
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
  @spec execute(config :: DiagnosticsConfig.t(), snapshot :: NodeSnapshot.t()) ::
          ProbeResult.t()
  def execute(config, snapshot) do
    metadata = get_metadata()
    component_type = get_component_type()

    calculated_threshold =
      compute_threshold(
        config.probes.socket_usage_threshold_coefficient,
        snapshot.operating_system.socket_descriptors.available
      )

    probe_data = [
      ProbeData.new(
        property_name: "operating_system.socket_descriptors.used",
        property_value: snapshot.operating_system.socket_descriptors.used
      ),
      ProbeData.new(
        property_name: "operating_system.socket_descriptors.available",
        property_value: snapshot.operating_system.socket_descriptors.available
      ),
      ProbeData.new(
        property_name: "socket_usage_threshold_coefficient",
        property_value: config.probes.socket_usage_threshold_coefficient
      ),
      ProbeData.new(
        property_name: "calculated_threshold",
        property_value: calculated_threshold
      )
    ]

    cond do
      is_unhealthy(
        snapshot.operating_system.socket_descriptors.used,
        snapshot.operating_system.socket_descriptors.available,
        calculated_threshold
      ) ->
        article =
          KnowledgeBaseArticle.new(
            reason:
              "The number of network sockets being used is equal to the max number available."
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

      is_warning(
        snapshot.operating_system.socket_descriptors.used,
        snapshot.operating_system.socket_descriptors.available
      ) ->
        article =
          KnowledgeBaseArticle.new(
            reason:
              "The number of network sockets being used is greater than the calculated high watermark but less than max number available."
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
              "The number of network sockets used is less than the calculated high watermark."
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
      "Fade.Diagnostic.Probes.SocketDescriptorThrottlingProbe"
      |> IdentifierGeneration.get_identifier()

    DiagnosticProbeMetadata.new(
      id: id,
      name: "Socket Descriptor Throttling Probe",
      description:
        "Checks network to see if the number of sockets currently in use is less than or equal to the number available."
    )
  end

  @impl DiagnosticProbe
  def get_component_type, do: :node

  @impl DiagnosticProbe
  def get_category, do: :throughput

  defp is_warning(socket_descriptors_used, socket_descriptors_available),
    do: socket_descriptors_used == socket_descriptors_available

  defp is_unhealthy(socket_descriptors_used, socket_descriptors_available, treshold),
    do: socket_descriptors_used < treshold and treshold <= socket_descriptors_available

  defp compute_threshold(threshold_coefficient, sockets_available) do
    case threshold_coefficient >= 1 do
      true ->
        sockets_available

      false ->
        :math.ceil(sockets_available * threshold_coefficient)
    end
  end
end
