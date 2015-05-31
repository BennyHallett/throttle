defmodule Throttle.FailOver do
  use GenServer
  require Logger

  def start_link(name \\ __MODULE__) do
    Logger.debug "Starting Throttle.FailOver with name #{name}"
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def enqueue(pair, pid \\ __MODULE__) do
    GenServer.cast pid, {:enqueue, pair}
  end

  def dequeue(pid \\ __MODULE__) do
    GenServer.call pid, :dequeue
  end

  def handle_call(:dequeue, _from, list) do
    {value, remaining} = do_dequeue(list)
    { :reply, value, remaining }
  end

  def handle_cast({:enqueue, pair}, list) do
    { :noreply, list ++ [pair] }
  end

  defp do_dequeue([]), do: {nil, []}
  defp do_dequeue([h|t]), do: {h, t}

end
