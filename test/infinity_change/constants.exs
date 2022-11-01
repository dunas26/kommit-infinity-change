defmodule InfinityChangeTest.Constants do
  use ExUnit.Case
  doctest InfinityChange

  test "constants has a get coins function" do
    assert Kernel.function_exported?(InfinityChange.Constants, :get_coins, 0)
  end

  test "constants return a coins constant list value" do
    coins = InfinityChange.Constants.get_coins()
    assert coins != nil
    assert is_list(coins)
  end
end
