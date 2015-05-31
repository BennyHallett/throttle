defmodule FailOverTest do
  alias Throttle.FailOver
  use ExUnit.Case, async: true

  test "Failover starts empty and dequeue returns nil" do
    {:ok, fo} = FailOver.start_link(:test)
    assert nil == FailOver.dequeue(fo)

    fo |> Process.exit(:kill)
  end

  test "Enqueue and Dequeue" do
    {:ok, fo} = FailOver.start_link(:test)

    FailOver.enqueue({1, 2}, fo)
    FailOver.enqueue({3, 4}, fo)
    assert {1, 2} == FailOver.dequeue(fo)
    FailOver.enqueue({5, 6}, fo)
    assert {3, 4} == FailOver.dequeue(fo)
    assert {5, 6} == FailOver.dequeue(fo)

    fo |> Process.exit(:kill)
  end

end
