defmodule TelemetryOtelDemo.AuthDB do
  @moduledoc """
  A mock persistence layer for user authentication data.
  """

  @data %{
    "bgottlob" => "password1",
    "jsmith" => "password2"
  }

  def authenticated?(username, password) do
    case Map.fetch(@data, username) do
      {:ok, actual} ->
        actual == password
      :error ->
        false
    end
  end
end
