defmodule TimeConverterTest do
  use ExUnit.Case, async: true

  test "1 second" do
    assert 1000 == Throttle.TimeConverter.convert({1, :second})
  end

  test "2.5 seconds" do
    assert 2500 == Throttle.TimeConverter.convert({2.5, :seconds})
  end

  test "2 minute" do
    assert 120000 == Throttle.TimeConverter.convert({2, :minute})
  end

  test "2.5 minutes" do
    assert 150000 == Throttle.TimeConverter.convert({2.5, :minutes})
  end

  test "1 hour" do
    assert 3600000 == Throttle.TimeConverter.convert({1, :hour})
  end

  test "2 hours" do
    assert 7200000 == Throttle.TimeConverter.convert({2, :hours})
  end

end
