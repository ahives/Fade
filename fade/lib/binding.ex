defmodule Fade.Binding do
  alias Fade.Broker

  def get_all() do
    url = "api/bindings"

    Broker.get_all_request(url)
  end
end
