defmodule Fade.Broker.DataMapper do
  @callback map_data(data :: list(any) | any) :: list(any) | any()
end
