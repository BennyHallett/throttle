defmodule Throttle.TimeConverter do

  @doc """
  Given a tuple matching `{amount, scale}`, convert it into
  the equivalent number of milliseconds.

  For example:

      Throttle.TimeConverter.convert {2, :seconds}
      => 2000

  A valid `amount` is any number.

  A valid `scale` is any of the following:

  * `:second`
  * `:seconds`
  * `:minute`
  * `:minutes`
  * `:hour`
  * `:hours`
  """
  def convert({amount, :second}),  do: amount * 1000
  def convert({amount, :seconds}), do: amount * 1000
  def convert({amount, :minute}),  do: amount * 1000 * 60
  def convert({amount, :minutes}), do: amount * 1000 * 60
  def convert({amount, :hour}),    do: amount * 1000 * 60 * 60
  def convert({amount, :hours}),   do: amount * 1000 * 60 * 60
end
