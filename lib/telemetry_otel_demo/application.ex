defmodule TelemetryOtelDemo.Application do
  @moduledoc """
  Controls the licefycle of the underlying Plug HTTP server.
  """
  use Application

  require Logger

  defp response_duration() do
    Telemetry.Metrics.distribution(
      "cowboy.response.duration",
      reporter_options: [buckets: [50, 100, 200, 500, 1000, 5000]],
      description: "Distribution of the response duration for HTTP endpoints",
      event_name: [:cowboy, :request, :stop],
      tag_values: fn %{
        req: %{method: method, path: path, port: port},
        resp_status: status
      } ->
          code =
            if is_binary(status) do
              case Regex.run(~r/^(\d+) .+$/, status, capture: :all_but_first) do
                [code] ->
                  code
                _ ->
                  :unknown
              end
            else
              :unknown
            end

        %{method: method, path: path, status: code, port: port}
      end,
      tags: [:method, :path, :port, :status],
      unit: {:nanosecond, :millisecond}
    )
  end

  defp metrics() do
    [
      Telemetry.Metrics.sum(
        "telemetry_otel_demo.auth.active_sessions",
        event_name: [:telemetry_otel_demo, :auth]
      ),
      response_duration()
    ]
  end

  def start(_type, _args) do
    port = System.get_env("PORT", "4000") |> String.to_integer()

    Logger.info("Starting HTTP server on port #{port}")

    # Supervise the Cowboy HTTP server process
    children = [
      {Plug.Cowboy, scheme: :http, plug: TelemetryOtelDemo.Router, options: [port: port]},
      {TelemetryMetricsPrometheus, [metrics: metrics()]}
    ]

    :ok =
      :telemetry.attach(
        "request-handler",
        [:cowboy, :request, :stop],
        &TelemetryOtelDemo.PlugTelemetryHandler.handle_event/4,
        nil
      )

    opts = [strategy: :one_for_one, name: TelemetryOtelDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
