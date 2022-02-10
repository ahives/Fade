defmodule Fade.Diagnostic.Scanner.BrokerQueuesScanner do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.Scanner.DiagnosticScanner
  alias Fade.Diagnostic.Types.ProbeResult
  alias Fade.Snapshot.Types.BrokerQueuesSnapshot
  alias Fade.DiagnosticScannerError

  @behaviour DiagnosticScanner

  @impl DiagnosticScanner
  def get_metadata do
    :not_implemented
  end

  def scan(nil, _probes, _snapshot) do
    {:error, %DiagnosticScannerError{message: "Configuration not found."}}
  end

  def scan(_config, nil, _snapshot) do
    {:error, %DiagnosticScannerError{message: "Diagnostic probes not found."}}
  end

  def scan(_config, _probes, nil) do
    {:error, %DiagnosticScannerError{message: "Snapshot cannot be empty."}}
  end

  @impl DiagnosticScanner
  @spec scan(
          config :: DiagnosticsConfig.t(),
          probes :: list(any),
          snapshot :: BrokerQueuesSnapshot.t()
        ) :: {:ok, list(ProbeResult)} | {:error, DiagnosticScannerError.t()}
  def scan(config, probes, snapshot) do
    queue_probes = get_queue_probes(probes)
    exchange_probes = get_exchange_probes(probes)

    exchange_readout = get_probe_readout(config, exchange_probes, snapshot)

    queue_readout =
      snapshot.queues
      |> Enum.reduce([], fn queue_snapshot, queue_results ->
        [get_probe_readout(config, queue_probes, queue_snapshot) | queue_results]
      end)
      |> Enum.filter(fn readout -> Enum.empty?(readout) end)

    {:ok, [exchange_readout | queue_readout]}
  end

  defp get_queue_probes(probes) do
    probes
    |> Stream.reject(&is_nil/1)
    |> Enum.filter(fn x -> x.get_component_type() == :queue end)
  end

  defp get_exchange_probes(probes) do
    probes
    |> Stream.reject(&is_nil/1)
    |> Enum.filter(fn x -> x.get_component_type() == :exchange end)
  end

  defp get_probe_readout(config, probes, snapshot) do
    probes
    |> Enum.reduce([], fn probe, results -> [probe.execute(config, snapshot) | results] end)
  end
end
