defmodule Fade.Broker.ServerTypes do
  use TypedStruct

  alias Fade.Broker.QueueTypes.QueueInfo
  alias Fade.Broker.BindingTypes.BindingInfo
  alias Fade.Broker.ExchangeTypes.ExchangeInfo
  alias Fade.Broker.GlobalParameterTypes.GlobalParameterInfo
  alias Fade.Broker.PolicyTypes.PolicyInfo
  alias Fade.Broker.ScopedParameterTypes.ScopedParameterInfo
  alias Fade.Broker.TopicPermissionTypes.TopicPermissionsInfo
  alias Fade.Broker.UserPermissionTypes.UserPermissionsInfo
  alias Fade.Broker.UserTypes.UserInfo
  alias Fade.Broker.VirtualHostTypes.VirtualHostInfo

  typedstruct module: ServerInfo do
    field(:rabbitmq_version, String.t())
    field(:users, list(UserInfo))
    field(:virtual_hosts, list(VirtualHostInfo))
    field(:permissions, list(UserPermissionsInfo))
    field(:policies, list(PolicyInfo))
    field(:parameters, list(ScopedParameterInfo))
    field(:global_parameters, list(GlobalParameterInfo))
    field(:queues, list(QueueInfo))
    field(:exchanges, list(ExchangeInfo))
    field(:bindings, list(BindingInfo))
    field(:topic_permissions, list(TopicPermissionsInfo))

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
