defmodule InfinityChange do
  import InfinityChange.Constants, only: [values: 0]
  alias InfinityChange.Constants, as: Const

  @moduledoc """
  # InfinityChange Documentation

  Compute coin change. This modules computes how many possibilites are when returning a coin
  """
  @spec get_lower_coins(integer(), list()) :: [integer()]
  defp get_lower_coins(value, opts) do
    ignore_equal = Keyword.get(opts, :ignore_equal, false)

    Enum.filter(
      Const.get(:coins),
      fn
        x when ignore_equal -> x < value
        x -> x <= value
      end
    )
  end

  @spec generate_max_result(integer()) :: [integer()]
  defp generate_max_result(change, opts \\ [ignore_equal: false]) do
    generate_raw_max_result(change, opts) |> List.flatten()
  end

  @spec generate_raw_max_result(integer(), list()) :: [integer()]
  defp generate_raw_max_result(change, _opts) when change == 0, do: nil

  defp generate_raw_max_result(change, opts) do
    ignore_equal = Keyword.get(opts, :ignore_equal, false)
    lower_coins = get_lower_coins(change, ignore_equal: ignore_equal)
    highest_coin = List.last(lower_coins)
    n_coins = change / highest_coin
    whole_coins = trunc(n_coins)
    part_coins = n_coins - whole_coins

    if abs(part_coins) > 0.00001 do
      rest = round(part_coins * highest_coin)
      [generate_max_result(rest) | generate_coins(highest_coin, whole_coins)]
    else
      generate_coins(highest_coin, whole_coins)
    end
  end

  @spec generate_coins(integer(), integer()) :: [integer()]
  defp generate_coins(coin, times) do
    List.duplicate(coin, times)
  end

  defp sort_coins(coin_list) do
    Enum.sort(coin_list, fn x, y -> x > y end)
  end

  @spec compute_coin_change(integer()) :: [[integer()]]
  def compute_coin_change(change) when change <= 0, do: []

  def compute_coin_change(change) do
    max = generate_max_result(change, ignore_equal: true)
  end

  def can_subdivide?(num, pivot_coin) when is_number(num), do: num > pivot_coin

  def can_subdivide?(list, pivot_coin) when is_list(list) do
    if Enum.all?(list, &is_number(&1)) do
      Enum.any?(list, fn x -> x > pivot_coin end)
    else
      [head | tail] = list

      unless Enum.empty?(tail) do
        can_subdivide?(head, pivot_coin) or can_subdivide?(tail, pivot_coin)
      else
        can_subdivide?(head, pivot_coin)
      end
    end
  end

  def solve(num) when is_number(num), do: solve([num])

  def solve([]), do: []

  def solve(list) when is_list(list) do
    [l_coin | _coins] = Const.get(:coins)
    idx = Enum.find_index(list, &can_subdivide?(&1, l_coin))

    unless !idx do
      el = Enum.at(list, idx)
      res = generate_max_result(el, ignore_equal: true)
      List.replace_at(list, idx, res) |> List.flatten()
    else
      []
    end
  end

  def generate_possibilities(num, _opts \\ [append: 0]) when num == 1, do: 1

  def generate_possibilities(num, opts) when is_number(num) do
    [l_coin | _coins] = Const.get(:coins)
    append_value = Keyword.get(opts, :append, 2)
    res = solve_coin(num)

    unless can_subdivide?(res, l_coin) do
      res
    else
      [h | t] = res
      [[h, generate_possibilities(h)] | generate_possibilities(t)]
    end
  end

  def generate_possibilities([], _opts), do: []

  def generate_possibilities([h | t], _opts) do
    [l_coin | _coins] = Const.get(:coins)
    # Ordenar el output de datos
    if can_subdivide?(t, l_coin) do
      [[h, generate_possibilities(h)] | generate_possibilities(t)]
    else
      [[h, generate_possibilities(h)]]
    end
  end

  @spec solve_coin(integer()) :: list()
  def solve_coin(coin) when coin <= 0, do: []
  def solve_coin(coin) when coin == 1, do: [1]

  def solve_coin(coin) do
    generate_max_result(coin, ignore_equal: true)
  end
end
