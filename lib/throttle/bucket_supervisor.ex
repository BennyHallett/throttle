defmodule Throttle.BucketSupervisor do
  use Supervisor
  import Logger

  def start_link do
    Logger.debug "Starting BucketSupervisor"
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end

  def add(sup, burst_limit, ip) do
    {:ok, bucket} = Supervisor.start_child(sup, worker(Throttle.Bucket, [burst_limit], id: "bucket_#{ip}"))
    bucket
  end

end
