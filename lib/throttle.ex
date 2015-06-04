defmodule Throttle do
  use Application

  def start(_type, [burst_limit,interval|[]]) do
    Throttle.Supervisor.start_link(burst_limit, interval)
  end
end
