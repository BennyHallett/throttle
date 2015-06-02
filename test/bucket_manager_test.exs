defmodule BucketManagerTest do
  use ExUnit.Case, async: true
  alias Throttle.BucketManager
  alias Throttle.BucketSupervisor
  alias Throttle.FailOver

  test "register one hit with one ip" do
    {:ok, sup} = BucketSupervisor.start_link
    {:ok, fo} = FailOver.start_link(:test_1)
    {:ok, manager} = BucketManager.start_link(sup, fo, 10, :test_man)

    assert :ok == BucketManager.register_hit("1.2.3.4", manager)

    sup |> Process.exit(:kill)
    fo |> Process.exit(:kill)
    manager |> Process.exit(:kill)
  end

  test "register many hits with one ip" do
    {:ok, sup} = BucketSupervisor.start_link
    {:ok, fo} = FailOver.start_link(:test_1)
    {:ok, manager} = BucketManager.start_link(sup, fo, 3, :test_man)

    assert :ok == BucketManager.register_hit("1.2.3.4", manager)
    assert :ok == BucketManager.register_hit("1.2.3.4", manager)
    assert :ok == BucketManager.register_hit("1.2.3.4", manager)
    assert :error == BucketManager.register_hit("1.2.3.4", manager) #It's now full

    sup |> Process.exit(:kill)
    fo |> Process.exit(:kill)
    manager |> Process.exit(:kill)
  end

  test "register many hits with many ips" do
    {:ok, sup} = BucketSupervisor.start_link
    {:ok, fo} = FailOver.start_link(:test_1)
    {:ok, manager} = BucketManager.start_link(sup, fo, 3, :test_man)

    assert :ok == BucketManager.register_hit("1.2.3.4", manager)
    assert :ok == BucketManager.register_hit("1.2.3.5", manager)
    assert :ok == BucketManager.register_hit("1.2.3.5", manager)
    assert :ok == BucketManager.register_hit("1.2.3.6", manager)
    assert :ok == BucketManager.register_hit("1.2.3.5", manager)
    assert :ok == BucketManager.register_hit("1.2.3.2", manager)
    assert :error == BucketManager.register_hit("1.2.3.5", manager)
    assert :ok == BucketManager.register_hit("1.2.3.1", manager)

    sup |> Process.exit(:kill)
    fo |> Process.exit(:kill)
    manager |> Process.exit(:kill)
  end

end
