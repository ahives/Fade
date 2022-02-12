defmodule BrokerDataFetcher do
  alias Fade.Broker.ConnectionDataMapper, as: ConnectionMapper
  alias Fade.Broker.ChannelDataMapper, as: ChannelMapper
  alias Fade.Broker.SystemOverviewDataMapper, as: SystemOverviewMapper
  alias Fade.Broker.NodeDataMapper, as: NodeMapper
  alias Fade.Broker.QueueDataMapper, as: QueueMapper

  def get_connections do
    ObjectDeserializer.get_data(
      "/../../Documents/Git/Fade/fade/test/data/connection_info.json",
      &ConnectionMapper.map_data/1
    )
  end

  def get_channels do
    ObjectDeserializer.get_data(
      "/../../Documents/Git/Fade/fade/test/data/channel_info.json",
      &ChannelMapper.map_data/1
    )
  end

  def get_system_overview do
    ObjectDeserializer.get_data(
      "/../../Documents/Git/Fade/fade/test/data/system_overview_info.json",
      &SystemOverviewMapper.map_data/1
    )
  end

  def get_nodes do
    ObjectDeserializer.get_data(
      "/../../Documents/Git/Fade/fade/test/data/node_info.json",
      &NodeMapper.map_data/1
    )
  end

  def get_queues do
    ObjectDeserializer.get_data(
      "/../../Documents/Git/Fade/fade/test/data/queue_info.json",
      &QueueMapper.map_data/1
    )
  end
end
