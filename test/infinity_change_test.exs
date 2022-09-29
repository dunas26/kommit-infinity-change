defmodule InfinityChangeTest do
  use ExUnit.Case
  doctest InfinityChange

  test "exist and returns a value" do
    assert function_exported?(InfinityChange, :compute_coin_change, 1)
    assert InfinityChange.compute_coin_change(0) != nil
  end

  test "returns [] when change is 0 or negative" do
    assert InfinityChange.compute_coin_change(0) === []
    assert InfinityChange.compute_coin_change(-10) === []
    assert InfinityChange.compute_coin_change(-20) === []
  end

  test "returns [1] when change is 1" do
    assert InfinityChange.compute_coin_change(1) === [[1]]
  end

  test "returns [1, 1, 1] when change is 3" do
    assert InfinityChange.compute_coin_change(3) === [[1, 1, 1]]
  end

  test "returns a list with n values with the lowest coin" do
    assert InfinityChange.compute_coin_change(1) === [[1]]
    assert InfinityChange.compute_coin_change(2) === [[1, 1]]
    assert InfinityChange.compute_coin_change(3) === [[1, 1, 1]]
    assert InfinityChange.compute_coin_change(4) === [[1, 1, 1, 1]]
  end

  test "returns a list with 2 lists, each containing two different coin possibilities" do
    assert InfinityChange.compute_coin_change(5) === [[5], [1, 1, 1, 1, 1]]
    assert InfinityChange.compute_coin_change(6) === [[5, 1], [1, 1, 1, 1, 1, 1]]
    assert InfinityChange.compute_coin_change(7) === [[5, 1, 1], [1, 1, 1, 1, 1, 1, 1]]
    assert InfinityChange.compute_coin_change(8) === [[5, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1]]

    assert InfinityChange.compute_coin_change(9) === [
             [5, 1, 1, 1, 1],
             [1, 1, 1, 1, 1, 1, 1, 1, 1]
           ]
  end

  test "returns a list with n lists, each containing more than 3 different coin possibilities" do
    assert Enum.member?(InfinityChange.compute_coin_change(10), [10])
    assert Enum.member?(InfinityChange.compute_coin_change(10), [5, 5])
    assert Enum.member?(InfinityChange.compute_coin_change(10), [5, 1, 1, 1, 1, 1])
    assert Enum.member?(InfinityChange.compute_coin_change(10), [1, 1, 1, 1, 1, 1, 1, 1, 1, 1])

    assert Enum.member?(InfinityChange.compute_coin_change(13), [10, 1, 1, 1])
    assert Enum.member?(InfinityChange.compute_coin_change(13), [5, 5, 1, 1, 1])
    assert Enum.member?(InfinityChange.compute_coin_change(13), [5, 1, 1, 1, 1, 1, 1, 1, 1])

    assert Enum.member?(InfinityChange.compute_coin_change(13), [
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1
           ])

    assert Enum.member?(InfinityChange.compute_coin_change(15), [10, 5])
    assert Enum.member?(InfinityChange.compute_coin_change(15), [10, 1, 1, 1, 1, 1])
    assert Enum.member?(InfinityChange.compute_coin_change(15), [5, 5, 1, 1, 1, 1, 1])
    assert Enum.member?(InfinityChange.compute_coin_change(15), [5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])

    assert Enum.member?(InfinityChange.compute_coin_change(15), [
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1
           ])

    assert Enum.member?(InfinityChange.compute_coin_change(18), [10, 5, 1, 1, 1])
    assert Enum.member?(InfinityChange.compute_coin_change(18), [5, 5, 5, 1, 1, 1])
    assert Enum.member?(InfinityChange.compute_coin_change(18), [5, 5, 1, 1, 1, 1, 1, 1, 1, 1])

    assert Enum.member?(InfinityChange.compute_coin_change(18), [
             5,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1
           ])

    assert Enum.member?(InfinityChange.compute_coin_change(24), [10, 10, 1, 1, 1, 1])
    assert Enum.member?(InfinityChange.compute_coin_change(24), [10, 5, 5, 1, 1, 1, 1])
    assert Enum.member?(InfinityChange.compute_coin_change(24), [5, 5, 5, 5, 1, 1, 1, 1])

    assert Enum.member?(InfinityChange.compute_coin_change(24), [
             5,
             5,
             5,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1,
             1
           ])

    assert Enum.member?(InfinityChange.compute_coin_change(24), [10, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1])
  end
end
