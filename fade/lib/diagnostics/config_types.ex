defmodule Fade.Diagnostic.Config.Types do
  use TypedStruct

  typedstruct module: DiagnosticsConfig do
    field(:probes, ProbesConfig.t())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end

  typedstruct module: ProbesConfig do
    field(:high_connection_closure_rate_threshold, integer())
    field(:high_connection_creation_rate_threshold, integer())
    field(:queue_high_flow_threshold, integer())
    field(:queue_low_flow_threshold, integer())
    field(:message_redelivery_threshold_coefficient, integer())
    field(:socket_usage_threshold_coefficient, integer())
    field(:runtime_process_usage_threshold_coefficient, integer())
    field(:file_descriptor_usage_threshold_coefficient, integer())
    field(:consumer_utilization_threshold, integer())

    def new(fields) do
      struct!(__MODULE__, fields)
    end
  end
end
