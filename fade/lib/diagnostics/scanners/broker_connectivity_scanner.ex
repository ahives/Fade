defmodule Fade.Diagnostic.Scanner.BrokerConnectivityScanner do
  alias Fade.Diagnostic.Config.Types.DiagnosticsConfig
  alias Fade.Diagnostic.Config.Types.ProbesConfig
  alias Fade.Diagnostic.Scanner.DiagnosticScanner
  alias Fade.Diagnostic.Types.ProbeResult
  alias Fade.Snapshot.Types.BrokerConnectivitySnapshot

  @behaviour DiagnosticScanner

  @impl DiagnosticScanner
  def get_metadata do
    :not_implemented
  end

  @impl DiagnosticScanner
  @spec scan(probes :: list(any), snapshot :: BrokerConnectivitySnapshot.t()) :: list(ProbeResult)
  def scan(probes, snapshot) do
    config =
      DiagnosticsConfig.new(
        probes:
          ProbesConfig.new(
            high_connection_closure_rate_threshold: 100,
            high_connection_creation_rate_threshold: 100
          )
      )

    connectivity_probes = get_connectivity_probes(probes)
    channel_probes = get_channel_probes(probes)
    connection_probes = get_connection_probes(probes)

    connectivity_readout = get_connectivity_probe_readout(config, connectivity_probes, snapshot)

    connection_readout =
      snapshot.connections
      |> Enum.reduce([], fn connection_snapshot, connection_results ->
        readouts = [
          get_channel_probe_readout(config, channel_probes, connection_snapshot.channels)
          | get_connection_probe_readout(config, connection_probes, connection_snapshot)
        ]

        [readouts | connection_results]
      end)

    [connectivity_readout | connection_readout]
  end

  defp get_connectivity_probes(probes) do
    probes
    |> Stream.reject(&is_nil/1)
    |> Enum.filter(fn x ->
      (x.get_component_type() == :connection or x.get_component_type() == :channel) and
        x.get_category() == :connectivity
    end)
  end

  defp get_channel_probes(probes) do
    probes
    |> Stream.reject(&is_nil/1)
    |> Enum.filter(fn x ->
      x.get_component_type() == :channel and x.get_category() == :connectivity
    end)
  end

  defp get_connection_probes(probes) do
    probes
    |> Stream.reject(&is_nil/1)
    |> Enum.filter(fn x ->
      x.get_component_type() == :connection and x.get_category() == :connectivity
    end)
  end

  defp get_connectivity_probe_readout(config, probes, snapshot) do
    probes
    |> Enum.reduce([], fn probe, results -> [probe.execute(config, snapshot) | results] end)
  end

  defp get_channel_probe_readout(config, probes, channel_snapshots) do
    channel_snapshots
    |> Enum.reduce([], fn channel_snapshot, results ->
      [
        get_channel_probe_results(config, probes, channel_snapshot)
        | results
      ]
    end)
  end

  defp get_channel_probe_results(config, probes, snapshot) do
    probes
    |> Enum.reduce([], fn probe, results -> [probe.execute(config, snapshot) | results] end)
  end

  defp get_connection_probe_readout(config, probes, snapshot) do
    probes
    |> Enum.reduce([], fn probe, results -> [probe.execute(config, snapshot) | results] end)
  end
end
