defmodule Fade.Diagnostic.Scanner.ClusterScanner do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.Scanner.DiagnosticScanner
  alias Fade.Diagnostic.Types.ProbeResult
  alias Fade.Snapshot.Types.ClusterSnapshot
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
          snapshot :: ClusterSnapshot.t()
        ) :: {:ok, list(ProbeResult)} | {:error, DiagnosticScannerError.t()}
  def scan(config, probes, snapshot) do
    node_probes = get_probes(probes, :node)
    disk_probes = get_probes(probes, :disk)
    memory_probes = get_probes(probes, :memory)
    runtime_probes = get_probes(probes, :runtime)
    os_probes = get_probes(probes, :operating_system)

    node_readout =
      snapshot.nodes
      |> Enum.reduce([], fn snapshot, readouts ->
        [get_probe_readout(config, node_probes, snapshot) | readouts]
      end)

    disk_readout =
      snapshot.nodes
      |> Enum.reduce([], fn snapshot, readouts ->
        [get_probe_readout(config, disk_probes, snapshot.disk) | readouts]
      end)

    memory_readout =
      snapshot.nodes
      |> Enum.reduce([], fn snapshot, readouts ->
        [get_probe_readout(config, memory_probes, snapshot.memory) | readouts]
      end)

    runtime_readout =
      snapshot.nodes
      |> Enum.reduce([], fn snapshot, readouts ->
        [get_probe_readout(config, runtime_probes, snapshot.runtime) | readouts]
      end)

    os_readout =
      snapshot.nodes
      |> Enum.reduce([], fn snapshot, readouts ->
        [get_probe_readout(config, os_probes, snapshot.operating_system) | readouts]
      end)

    readouts = node_readout ++ disk_readout ++ memory_readout ++ runtime_readout ++ os_readout

    {:ok, readouts}
  end

  defp get_probes(probes, component_type) do
    probes
    |> Stream.reject(&is_nil/1)
    |> Enum.filter(fn x -> x.get_component_type() == component_type end)
  end

  defp get_probe_readout(config, probes, snapshot) do
    probes
    |> Enum.reduce([], fn probe, results -> [probe.execute(config, snapshot) | results] end)
  end
end
