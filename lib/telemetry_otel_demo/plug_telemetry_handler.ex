defmodule TelemetryOtelDemo.PlugTelemetryHandler do

  def handle_event([:cowboy, :request, :stop], measurements, metadata, _config) do
    IO.inspect metadata
    IO.inspect measurements
  end
end
