defmodule Throttle.Plug.RateLimiter do
  @moduledoc """
  A plug to limit the number of requests any one client can send in a specified time period.
  """

  @behaviour Plug

  @doc """
  Callback function for `Plug.init/1`.
  """
  def init(opts = %{ burst_limit: burst_limit, interval: {amount, scale}}) do
    Throttle.start :temporary, [burst_limit, {amount, scale}]
    opts
  end

  @doc """
  Callback function for `Plug.call/2`.
  """
  def call(conn = %Plug.Conn{ remote_ip: {a, b, c, d} }) do
    result = [a, b, c, d]
    |> Enum.map(fn i -> to_string(i) end)
    |> Enum.join(".")
    |> Throttle.BucketManager.register_hit
    |> process_result(conn)
  end
  def call(conn, _opts), do: conn

  defp process_result(:error, conn) do
    conn
    |> Plug.Conn.send_resp(500, "Too many requests")
  end
  defp process_result(:ok, conn), do: conn

end
