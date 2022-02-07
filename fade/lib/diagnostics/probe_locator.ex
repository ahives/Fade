defmodule Fade.Diagnostic.ProbeLocator do
  # alias Fade.Diagnostic.DiagnosticProbe

  alias Fade.Diagnostic.Probes.{
    AvailableCpuCoresProbe,
    BlockedConnectionProbe,
    ChannelLimitReachedProbe,
    ChannelThrottlingProbe,
    ConsumerUtilizationProbe,
    HighConnectionClosureRateProbe,
    HighConnectionCreationRateProbe,
    DiskAlarmProbe,
    FileDescriptorThrottlingProbe,
    MemoryAlarmProbe,
    MessagePagingProbe,
    NetworkPartitionProbe,
    QueueGrowthProbe,
    QueueHighFlowProbe,
    QueueLowFlowProbe,
    QueueNoFlowProbe,
    RedeliveredMessagesProbe,
    RuntimeProcessLimitProbe,
    SocketDescriptorThrottlingProbe,
    UnlimitedPrefetchCountProbe,
    UnroutableMessageProbe
  }

  def find_probes do
    [
      AvailableCpuCoresProbe,
      BlockedConnectionProbe,
      ChannelLimitReachedProbe,
      ChannelThrottlingProbe,
      ConsumerUtilizationProbe,
      HighConnectionClosureRateProbe,
      HighConnectionCreationRateProbe,
      DiskAlarmProbe,
      FileDescriptorThrottlingProbe,
      MemoryAlarmProbe,
      MessagePagingProbe,
      NetworkPartitionProbe,
      QueueGrowthProbe,
      QueueHighFlowProbe,
      QueueLowFlowProbe,
      QueueNoFlowProbe,
      RedeliveredMessagesProbe,
      RuntimeProcessLimitProbe,
      SocketDescriptorThrottlingProbe,
      UnlimitedPrefetchCountProbe,
      UnroutableMessageProbe
    ]

    # for {module, _} <- :code.all_loaded(),
    #     DiagnosticProbe in (module.module_info(:attributes)[:behaviour] || []) do
    #   module
    # end
  end
end
