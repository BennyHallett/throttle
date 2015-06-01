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

  def add(sup, burst_limit) do
    {:ok, bucket} = Supervisor.start_child(sup, worker(Throttle.Bucket, [burst_limit]))
    bucket
  end

end
