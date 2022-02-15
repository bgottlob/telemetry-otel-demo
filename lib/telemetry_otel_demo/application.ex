defmodule TelemetryOtelDemo.Application do
  @moduledoc """
  Controls the licefycle of the underly Plug HTTP server.
  """
  use Application

  require Logger

  def start(_type, _args) do
    port = System.get_env("PORT", "4000") |> String.to_integer()

    Logger.info("Starting HTTP server on port #{port}")

    # Supervise the Cowboy HTTP server process
    children = [
      {Plug.Cowboy, scheme: :http, plug: TelemetryOtelDemo.Router, options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: TelemetryOtelDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
