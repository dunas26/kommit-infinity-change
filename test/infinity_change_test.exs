defmodule InfinityChangeTest do
  use ExUnit.Case
  doctest InfinityChange

  test "exist and returns a value" do
    assert InfinityChange.compute_coin_change(0) != nil
  end

	test "returns 0 when change is 0 or negative" do
		assert InfinityChange.compute_coin_change(0) === 0
		assert InfinityChange.compute_coin_change(-10) === 0
		assert InfinityChange.compute_coin_change(-20) === 0
	end

	test "returns [1] when change is 1" do
		assert InfinityChange.compute_coin_change(1) === [1]
	end

end
