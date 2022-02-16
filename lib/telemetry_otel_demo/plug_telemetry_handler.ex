defmodule TelemetryOtelDemo.PlugTelemetryHandler do

  def handle_event(_, measurements, metadata, _config) do
    IO.inspect metadata
    IO.inspect measurements
  end
end
