defmodule Fade.Types do
  use TypedStruct

  typedstruct module: BindingInfo do
    field(:source, String.t())
    field(:virtual_host, String.t())
    field(:destination, String.t())
    field(:destination_type, String.t())
    field(:routing_key, String.t())
    field(:arguments, Map.t(), default: %{})
    field(:properties_key, String.t())
  end

  typedstruct module: Error do
    field(:reason, String.t())
    field(:timestamp, DateTime.t())

    def new(fields) do
      struct!(Error, Keyword.merge([timestamp: DateTime.utc_now()], fields))
    end
  end

  typedstruct module: DebugInfo do
    field(:url, String.t())
    field(:request, String.t())
    field(:response, String.t())
    field(:error, Error.t(), default: %Error{})
  end

  typedstruct module: Result do
    field(:data, String.t())
    field(:has_data, boolean(), default: false)
    field(:debug, DebugInfo.t())
    field(:has_faulted, boolean(), default: false)
    field(:timestamp, DateTime.t())

    def new(fields) do
      struct!(Result, Keyword.merge([timestamp: DateTime.utc_now()], fields))
    end
  end
end
