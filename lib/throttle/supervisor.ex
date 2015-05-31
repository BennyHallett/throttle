defmodule Throttle.Supervisor do
  use Supervisor

  def start_link do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [])
    start_workers(sup)
    result
  end

  def start_workers(sup) do
    {:ok, failover} = Supervisor.start_child(sup, worker(Throttle.FailOver, []))
    #{:ok, bucket_sup} = Supervisor.start_child(sup, supervisor(Throttle.BucketSupervisor, []))
    #Supervisor.start_child(sup, worker(Throttle.BucketManager, [bucket_sup, failover]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end

end
