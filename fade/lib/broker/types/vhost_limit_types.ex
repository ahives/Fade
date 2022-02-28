defmodule Fade.Broker.VirtualHostLimitTypes do
  use TypedStruct
  require Protocol

  # typedstruct module: VirtualHostLimitsRequest do
  #   field(:, )
  #   field(:, )
  # end
  typedstruct module: VirtualHostLimitInfo do
    field(:vhost, String.t())
    field(:limits, map())

    def new(fields), do: struct!(__MODULE__, fields)
  end
end
