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

  @spec calculate(integer()) :: [[integer()]]
  defp calculate(change) when change <= 0, do: []

  defp calculate(change) do
    max =
      change
      |> generate_max_result(ignore_equal: false)

    (subdivide(max) ++ subdivide(max, flip: true))
    |> Enum.uniq()
  end

  defp subdivide(result, opts \\ [flip: false]) do
    [lowest_coin | _coins] = Const.get(:coins)

    result = if Keyword.get(opts, :flip, false), do: result |> sort_coins, else: result
    idx = Enum.find_index(result, fn x -> x > lowest_coin end)

    unless idx == nil do
      value = Enum.at(result, idx)

      next_list =
        List.replace_at(result, idx, generate_max_result(value, ignore_equal: true))
        |> List.flatten()

      [result |> sort_coins | subdivide(next_list, opts)]
    else
      [result]
    end
  end

  def subdivide_testing(result) do
    subdivide(result) |> Enum.reverse()
  end

  defp sort_coins(coin_list) do
    Enum.sort(coin_list, fn x, y -> x > y end)
  end

  @spec compute_coin_change(integer()) :: [[integer()]]
  def compute_coin_change(change) when change <= 0, do: []

  def compute_coin_change(change) do
    calculate(change)
  end

  def pretty_print(list) when is_list(list) do
    string_list = Enum.map(list, fn x -> Enum.join(x, ", ") end)
    Enum.each(string_list, fn x -> IO.puts(x) end)
  end
end
