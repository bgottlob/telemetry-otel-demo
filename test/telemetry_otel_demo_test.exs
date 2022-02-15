defmodule TelemetryOtelDemoTest do
  use ExUnit.Case
  doctest TelemetryOtelDemo

  test "greets the world" do
    assert TelemetryOtelDemo.hello() == :world
  end
end
