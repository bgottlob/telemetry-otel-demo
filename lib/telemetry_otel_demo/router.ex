defmodule TelemetryOtelDemo.Router do
  @moduledoc """
  Router for HTTP endpoints.
  """

  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  forward("/login", to: TelemetryOtelDemo.AuthRouter)

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
