defmodule TelemetryOtelDemo.AuthRouter do
  use Plug.Router

  alias TelemetryOtelDemo.AuthDB

  plug(
    Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason
  )
  plug(:match)
  plug(:dispatch)

  post "/" do
    username = conn.body_params["username"]
    password = conn.body_params["password"]
    
    if AuthDB.authenticated?(username, password) do
      token = %{
        "username": username,
        "nonce": Enum.random(1..1_000_000)
      }
      |> Jason.encode!()
      |> Base.encode64()

      send_resp(conn, 200, token)
    else
      send_resp(conn, 401, "Incorrect username or password")
    end
  end

  delete "/" do
    send_resp(conn, 200, "Logged out")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
