defmodule InfinityChange.Generation do
  alias InfinityChange.DataProvider
  alias InfinityChange.Constants, as: Const

  @doc """
  Generates a possibility map from a given integer
  """
  @spec map_possibilities(integer()) :: list()
  def map_possibilities(change) do
    generate_possibilities(change) |> chunk_by_initial_isolated
  end

  @doc """
  Generate a set of same coins that add up to the final change

  ## Example
    iex> InfinityChange.Generation.generate_periodical_coins(50)
    [
      [25,25],
      [10,10,10,10,10],
      [5,5,5,5,5,5,5,5,5,5],
      [1,1,...1]
    ]
  """
  @spec generate_periodical_coins(integer()) :: list()
  def generate_periodical_coins(change) when change <= 0, do: []

  def generate_periodical_coins(change) do
    coins = DataProvider.get_lower_coins(change, ignore_equal: true)
    recurse_periodic_coins(change, strip_lowest_coin(coins))
  end

  @spec recurse_possibility(list(), boolean()) :: list()
  defp recurse_possibility([], _), do: []
  defp recurse_possibility(list, false) when is_list(list), do: list

  defp recurse_possibility([1 | t], _can_subd) do
    [1 | generate_possibilities(t)]
  end

  defp recurse_possibility([h | t], _can_subd) do
    [[h, generate_possibilities(h)] | generate_possibilities(t)]
  end

  defp generate_possibilities(1), do: [1]
  defp generate_possibilities([]), do: []

  defp generate_possibilities(list) when is_list(list) do
    # Ordenar el output de datos
    recurse_possibility(list, DataProvider.can_subdivide?(list))
  end

  defp generate_possibilities(num) when is_number(num) do
    res = solve_coin(num)
    recurse_possibility(res, DataProvider.can_subdivide?(res))
  end

  @spec chunk_by_initial_isolated(list()) :: list()
  defp chunk_by_initial_isolated(possibility) do
    n = 1
    n_count = possibility |> Enum.count(&(&1 === n))
    process_chunk(possibility, n, n_count)
  end

  @spec process_chunk(list(), number(), number()) :: list()
  defp process_chunk(p, _n, 0), do: p

  defp process_chunk(possibility, n, n_count) do
    stripped = possibility |> Enum.drop(n_count)
    [[List.duplicate(n, n_count)] | stripped]
  end

  @spec generate_max_result(integer()) :: [integer()]
  defp generate_max_result(change, opts \\ [ignore_equal: false]) do
    generate_raw_max_result(change, opts) |> List.flatten()
  end

  @spec generate_raw_max_result(integer(), list()) :: [integer()]
  defp generate_raw_max_result(0, _opts), do: nil

  defp generate_raw_max_result(change, opts) do
    ignore_equal = Keyword.get(opts, :ignore_equal, false)
    lower_coins = DataProvider.get_lower_coins(change, ignore_equal: ignore_equal)
    highest_coin = List.last(lower_coins)
    n_coins = change / highest_coin
    whole_coins = trunc(n_coins)
    part_coins = n_coins - whole_coins
    recurse_coin_result(part_coins, whole_coins, highest_coin)
  end

  @spec recurse_coin_result(number(), number(), number()) :: any()
  defp recurse_coin_result(0.0, whole_coin, highest_coin),
    do: generate_coins(highest_coin, whole_coin)

  defp recurse_coin_result(part_coins, whole_coin, highest_coin) do
    rest = round(part_coins * highest_coin)
    [generate_max_result(rest) | generate_coins(highest_coin, whole_coin)]
  end

  @spec generate_coins(integer(), integer()) :: [integer()]
  defp generate_coins(coin, times) do
    List.duplicate(coin, times)
  end

  @spec solve_coin(integer()) :: list()
  defp solve_coin(coin) when coin <= 0, do: []
  defp solve_coin(1), do: [1]

  defp solve_coin(coin) do
    generate_max_result(coin, ignore_equal: true)
  end

  @spec strip_lowest_coin(list()) :: list()
  defp strip_lowest_coin([]), do: []

  defp strip_lowest_coin([_h | t]), do: t

  @spec recurse_periodic_coins(integer(), list()) :: list()
  defp recurse_periodic_coins(change, _) when change <= 0, do: []
  defp recurse_periodic_coins(_, []), do: []

  defp recurse_periodic_coins(change, [h | t]) when is_list([h | t]) do
    coin_count = change / h
    decimal_part = coin_count - trunc(coin_count)
    should_generate = abs(decimal_part) < 0.0000001
    coin_res = generate_coins_gate(h, trunc(coin_count), should_generate)
    prepend_gate(coin_res, recurse_periodic_coins(change, t), not Enum.empty?(coin_res))
  end

  @spec prepend_gate(term(), list(), boolean()) :: list()
  defp prepend_gate(_, list, false), do: list

  defp prepend_gate(value, list, _should) do
    [value | list]
  end

  @spec generate_coins_gate(integer(), integer(), boolean()) :: list()
  defp generate_coins_gate(_, _, false), do: []

  defp generate_coins_gate(coin, times, _should) do
    generate_coins(coin, times)
  end
end
