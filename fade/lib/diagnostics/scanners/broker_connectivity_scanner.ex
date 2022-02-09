defmodule Fade.Diagnostic.Scanner.BrokerConnectivityScanner do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.Scanner.DiagnosticScanner
  alias Fade.Diagnostic.Types.ProbeResult
  alias Fade.Snapshot.Types.BrokerConnectivitySnapshot
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
          snapshot :: BrokerConnectivitySnapshot.t()
        ) :: {:ok, list(ProbeResult)} | {:error, DiagnosticScannerError.t()}
  def scan(config, probes, snapshot) do
    broker_connectivity_probes = get_broker_connectivity_probes(probes)
    channel_probes = get_channel_probes(probes)
    connection_probes = get_connection_probes(probes)

    broker_connectivity_readout = get_probe_readout(config, broker_connectivity_probes, snapshot)

    connection_readout =
      snapshot.connections
      |> Enum.reduce([], fn snapshot, readouts ->
        [get_probe_readout(config, connection_probes, snapshot) | readouts]
      end)
      |> List.flatten()

    channel_readout =
      snapshot.connections
      |> Enum.reduce([], fn connection_snapshot, results ->
        [connection_snapshot.channels | results]
      end)
      |> List.flatten()
      |> Enum.reduce([], fn snapshot, readouts ->
        [get_probe_readout(config, channel_probes, snapshot) | readouts]
      end)
      |> List.flatten()

    readouts = connection_readout ++ channel_readout ++ broker_connectivity_readout

    {:ok, readouts}
  end

  defp get_broker_connectivity_probes(probes) do
    probes
    |> Stream.reject(&is_nil/1)
    |> Enum.filter(fn x ->
      x.get_component_type() == :broker and x.get_category() == :connectivity
    end)
  end

  defp get_channel_probes(probes) do
    probes
    |> Stream.reject(&is_nil/1)
    |> Enum.filter(fn x ->
      x.get_component_type() == :channel and x.get_category() != :connectivity
    end)
  end

  defp get_connection_probes(probes) do
    probes
    |> Stream.reject(&is_nil/1)
    |> Enum.filter(fn x ->
      x.get_component_type() == :connection and x.get_category() != :connectivity
    end)
  end

  defp get_probe_readout(config, probes, snapshot) do
    probes
    |> Enum.reduce([], fn probe, results -> [probe.execute(config, snapshot) | results] end)
  end
end
