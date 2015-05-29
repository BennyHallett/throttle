defmodule BucketTest do
  use ExUnit.Case, async: true

  test "create a new empty bucket" do
    {:ok, bucket} = Throttle.Bucket.start_link(100)

    assert 0 == Throttle.Bucket.count(bucket)
    assert 100 == Throttle.Bucket.burst_limit(bucket)
    assert false == Throttle.Bucket.full?(bucket)
  end

  test "fill bucket and returns ok" do
    {:ok, bucket} = Throttle.Bucket.start_link(100)

    response = bucket |> Throttle.Bucket.fill

    assert :ok == response
    assert 1 == Throttle.Bucket.count(bucket)
  end

  test "leak from bucket" do
    {:ok, bucket} = Throttle.Bucket.start_link(100)

    bucket |> Throttle.Bucket.fill
    bucket |> Throttle.Bucket.fill
    bucket |> Throttle.Bucket.fill

    assert 3 == Throttle.Bucket.count(bucket)

    bucket |> Throttle.Bucket.leak

    assert 2 == Throttle.Bucket.count(bucket)
  end

  test "leak from empty bucket stays zero" do
    {:ok, bucket} = Throttle.Bucket.start_link(100)

    bucket |> Throttle.Bucket.leak

    assert 0 == Throttle.Bucket.count(bucket)
  end

  test "fill full bucket stays full and returns error" do
    {:ok, bucket} = Throttle.Bucket.start_link(1)

    bucket |> Throttle.Bucket.fill
    response = bucket |> Throttle.Bucket.fill

    assert response == :error
    assert 1 == Throttle.Bucket.count(bucket)
  end
end
