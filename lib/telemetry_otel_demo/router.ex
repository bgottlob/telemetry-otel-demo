defmodule TelemetryOtelDemo.Router do
  @moduledoc """
  Router for HTTP endpoints.
  """

  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  forward("/login", to: TelemetryOtelDemo.AuthRouter)

  get "/enlarge" do
    case fetch_query_params(conn) do
      %Plug.Conn{query_params: %{"phrase" => phrase}} ->
        capitalized =
          phrase
          |> String.to_charlist()
          |> Enum.count(fn char -> char >= ?a && char <= ?z end)

      :telemetry.execute(
        [:telemetry_otel_demo, :enlarge],
        %{characters_capitalized: capitalized},
        %{phrase: phrase}
      )

        send_resp(conn, 200, String.upcase(phrase))
      _ ->
        send_resp(conn, 400, "Query parameter `phrase` not included")
    end
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
