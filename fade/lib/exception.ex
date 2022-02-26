defmodule Fade.DiagnosticScannerError do
  defexception [:message]

  @type t :: %{
          required(:__struct__) => module,
          required(:__exception__) => true,
          required(:message) => String.t()
        }

  @impl true
  @spec message(t) :: String.t()
  def message(%{message: message}), do: message
end

defmodule Fade.ConfigurationMissingError do
  defexception [:message]

  @type t :: %{
          required(:__struct__) => module,
          required(:__exception__) => true,
          required(:message) => String.t()
        }

  @impl true
  @spec message(t) :: String.t()
  def message(%{message: message}), do: message
end

defmodule Fade.RabbitMqServerResponseError do
  defexception [:message]

  @type t :: %{
          required(:__struct__) => module,
          required(:__exception__) => true,
          required(:message) => String.t()
        }

  @impl true
  @spec message(t) :: String.t()
  def message(%{message: message}), do: message
end

defmodule Fade.VirtualHostMissingError do
  defexception [:message]

  @type t :: %{
          required(:__struct__) => module,
          required(:__exception__) => true,
          required(:message) => String.t()
        }

  @impl true
  @spec message(t) :: String.t()
  def message(%{message: message}), do: message
end

defmodule Fade.InvalidVirtualHostError do
  defexception [:message]

  @type t :: %{
          required(:__struct__) => module,
          required(:__exception__) => true,
          required(:message) => String.t()
        }

  @impl true
  @spec message(t) :: String.t()
  def message(%{message: message}), do: message
end
