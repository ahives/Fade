defmodule Fade.Diagnostic.Scanner.BrokerConnectivityScanner do
  alias Fade.Diagnostic.Scanner.DiagnosticScanner
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.Config.Types.ProbesConfig

  @behaviour DiagnosticScanner

  @impl DiagnosticScanner
  def get_metadata do
    :not_implemented
  end

  @impl DiagnosticScanner
  def scan(probes, snapshot) do
    config =
      DiagnosticsConfig.new(
        probes:
          ProbesConfig.new(
            high_connection_closure_rate_threshold: 100,
            high_connection_creation_rate_threshold: 100
          )
      )

    results = get_connection_probes(config, probes, snapshot)

    results
  end

  defp get_connection_probes(config, probes, snapshot) do
    probes
    |> Stream.reject(&is_nil/1)
    |> Enum.filter(fn x ->
      x.get_component_type() == :connection and x.get_category() == :connectivity
    end)
    |> Enum.reduce(fn probe -> probe.execute(config, snapshot) end)
  end
end
