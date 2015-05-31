defmodule Throttle do
  use Application

  def start(_type, _args) do
    Throttle.Supervisor.start_link
  end
end
