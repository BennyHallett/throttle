defmodule Throttle.BucketManager do
  use GenServer
  import Logger

  def start_link(sup, failover, burst_limit, name \\ __MODULE__)  do
    Logger.debug "Starting BucketManager"
    GenServer.start_link(__MODULE__, { sup, failover, burst_limit, %{} }, name: name)
  end

  def register_hit(ip_address, pid \\ __MODULE__) do
    GenServer.call pid, { :register_hit, ip_address }
  end

  def handle_call({ :register_hit, ip_address }, _from, { sup, failover, burst_limit, dict }) do
    { result, dict } = dict
    |> Dict.get(ip_address)
    |> _register_hit(dict, ip_address, sup, burst_limit)

    { :reply, result, { sup, failover, burst_limit, dict } }
  end

  defp _register_hit(nil, dict, ip_address, sup, burst_limit) do
    bucket = Throttle.BucketSupervisor.add(sup, burst_limit)
    dict = dict |> Dict.put(ip_address, bucket)
    result = bucket |> Throttle.Bucket.fill
    { result, dict }
  end

  defp _register_hit(bucket, dict, _, _, _) do
    result = bucket |> Throttle.Bucket.fill
    { result, dict }
  end

end
