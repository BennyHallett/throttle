defmodule Throttle.Timer do
  import Logger

  def start_link(interval = {amount, scale}) do
    i = Throttle.TimeConverter.convert(interval)

    pid = spawn(__MODULE__, :timer, [i, []])
    :global.register_name(__MODULE__, pid)
    { :ok, pid }
  end

  def register(bucket_pid) do
    send :global.whereis_name(__MODULE__), { :register, bucket_pid }
  end

  def timer(interval, buckets) do
    receive do
      { :register, bucket_pid } ->
        Logger.debug "Registering #{inspect bucket_pid}"
        timer(interval, [bucket_pid|buckets])
    after
      interval ->
        Logger.debug "Leaking for #{length buckets} buckets"

        Enum.each buckets, fn bucket ->
          Throttle.Bucket.leak
        end
        timer(interval, buckets)
    end
  end

end
