defmodule Throttle.Bucket do

  @doc """
  Starts a bucket with the given `burst_limit`.

  The `burst_limit` describes the maximum number of
  simultaneous requests the bucket can contain.

  This bucket implements the Leaky Bucket algorithm. For
  more info see: http://en.wikipedia.org/wiki/Leaky_bucket
  """
  def start_link(burst_limit) do
    {:ok, pid} = Agent.start_link(fn -> { 0, burst_limit } end)
    Throttle.Timer.register pid
    {:ok, pid}
  end

  @doc """
  The `count` function returns the current number of requests
  in the bucket.
  """
  def count(bucket) do
    Agent.get(bucket, fn({count, burst_limit}) -> count end)
  end

  @doc """
  The `burst_limit` function returns the maximum number of 
  simultaneous requests the bucket can contain.
  """
  def burst_limit(bucket) do
    Agent.get(bucket, fn({count, burst_limit}) -> burst_limit end)
  end

  @doc """
  The `full?` function returns full if the current `count` of
  the bucket matches the `burst_limit`. In this case, no more
  requests should be accepted.
  """
  def full?(bucket) do
    Agent.get(bucket, fn({count, burst_limit}) -> count >= burst_limit end)
  end

  @doc """
  The `fill` function increments the request counter by 1
  """
  def fill(bucket) do
    Agent.get_and_update(bucket, fn
      {burst_limit, burst_limit} -> {:error, {burst_limit, burst_limit}}
      {count, burst_limit}       -> {:ok, {count+1, burst_limit}}
    end)
  end

  @doc """
  The `leak` function decrements the request counter by 1
  """
  def leak(bucket) do
    Agent.update(bucket, fn
      {0, burst_limit}     -> {0, burst_limit}
      {count, burst_limit} -> {count-1, burst_limit}
    end)
  end
end
