defmodule Throttle do
  use Application

  def start(_type, [burst_limit|[]]) do
    Throttle.Supervisor.start_link(burst_limit)
  end
end
