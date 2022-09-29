defmodule InfinityChangeTest.Constants do
	use ExUnit.Case
	doctest InfinityChange

	test "constants has a value function" do
		assert Kernel.function_exported?(InfinityChange.Constants, :values, 0)
	end

	test "constants has a get function" do
		assert Kernel.function_exported?(InfinityChange.Constants, :get, 1)
	end

	test "constants return a coins constant list value" do
		coins = InfinityChange.Constants.get(:coins)
		assert coins != nil
		assert is_list(coins)
	end

	test "returns nil when a constant does not exist" do
		assert InfinityChange.Constants.get(:hello) == nil
	end

	test "returns true if value exists, false otherwise" do
		assert InfinityChange.Constants.has_value?(:coins) # true
		refute InfinityChange.Constants.has_value?(:hello) # false
	end
end
