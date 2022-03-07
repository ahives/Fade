defmodule Fade.Broker.ServerDataMapper do
  alias Fade.Broker.BindingDataMapper
  alias Fade.Broker.DataMapper
  alias Fade.Broker.ExchangeDataMapper
  alias Fade.Broker.GlobalParameterDataMapper
  alias Fade.Broker.PolicyDataMapper
  alias Fade.Broker.QueueDataMapper
  alias Fade.Broker.ScopedParameterDataMapper
  alias Fade.Broker.ServerTypes.ServerInfo
  alias Fade.Broker.TopicPermissionDataMapper
  alias Fade.Broker.UserDataMapper
  alias Fade.Broker.UserPermissionDataMapper
  alias Fade.Broker.VirtualHostDataMapper

  @behaviour DataMapper

  @impl DataMapper
  def map_data(data) do
    ServerInfo.new(
      rabbitmq_version: data["node"],
      users: UserDataMapper.map_data(data["users"]),
      virtual_hosts: VirtualHostDataMapper.map_data(data["vhosts"]),
      permissions: UserPermissionDataMapper.map_data(data["permissions"]),
      policies: PolicyDataMapper.map_data(data["policies"]),
      parameters: ScopedParameterDataMapper.map_data(data["parameters"]),
      global_parameters: GlobalParameterDataMapper.map_data(data["global_parameters"]),
      queues: QueueDataMapper.map_data(data["queues"]),
      exchanges: ExchangeDataMapper.map_data(data["exchanges"]),
      bindings: BindingDataMapper.map_data(data["bindings"]),
      topic_permissions: TopicPermissionDataMapper.map_data(data["topic_permissions"])
    )
  end
end
