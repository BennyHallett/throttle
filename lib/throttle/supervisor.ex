defmodule Throttle.Supervisor do
  use Supervisor
  import Logger

  def start_link(burst_limit) do
    Logger.debug "Starting Supervisor"
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [])
    start_workers(sup, burst_limit)
    result
  end

  def start_workers(sup, burst_limit) do
    {:ok, failover} = Supervisor.start_child(sup, worker(Throttle.FailOver, []))
    {:ok, bucket_sup} = Supervisor.start_child(sup, supervisor(Throttle.BucketSupervisor, []))
    Supervisor.start_child(sup, worker(Throttle.BucketManager, [bucket_sup, failover, burst_limit]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end

end
