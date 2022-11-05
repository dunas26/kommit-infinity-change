defmodule InfinityChange.Generation do
  @moduledoc false

  alias InfinityChange.DataProvider

  @doc """
  Generates a possibility map from a given integer
  """
  @spec map_possibilities(integer()) :: list()
  def map_possibilities(change) do
    change
    |> generate_possibilities()
    |> chunk_by_initial_isolated()
  end

  @doc """
  Generate a set of same coins that add up to the final change

  ## Example
    ```
    iex> InfinityChange.Generation.generate_periodical_coins(50)
    [
      [25,25],
      [10,10,10,10,10],
      [5,5,5,5,5,5,5,5,5,5],
      [1,1,...1]
    ]
    ```
  """
  @spec generate_periodical_coins(integer()) :: list()
  def generate_periodical_coins(change) when change <= 0, do: []

  def generate_periodical_coins(change) do
    coins =
      change
      |> DataProvider.get_lower_coins(ignore_equal: true)
      |> strip_lowest_coin()

    recurse_periodic_coins(change, coins)
  end

  @spec recurse_possibility(list(), boolean()) :: list()
  defp recurse_possibility([], _), do: []
  defp recurse_possibility(list, false) when is_list(list), do: list

  defp recurse_possibility([1 | tail], _can_subdivide) do
    [1 | generate_possibilities(tail)]
  end

  defp recurse_possibility([head | tail], _can_subdivide) do
    head_possibilities = generate_possibilities(head)
    tail_possibilities = generate_possibilities(tail)
    [[head, head_possibilities] | tail_possibilities]
  end

  defp generate_possibilities(1), do: [1]
  defp generate_possibilities([]), do: []

  defp generate_possibilities(list) when is_list(list) do
    # Ordenar el output de datos
    recurse_possibility(list, DataProvider.can_subdivide?(list))
  end

  defp generate_possibilities(number) when is_number(number) do
    number
    |> solve_coin()
    |> (&recurse_possibility(&1, DataProvider.can_subdivide?(&1))).()
  end

  @spec chunk_by_initial_isolated(list()) :: list()
  defp chunk_by_initial_isolated(possibility) do
    n_count = Enum.count(possibility, &(&1 === 1))
    process_chunk(possibility, 1, n_count)
  end

  @spec process_chunk(list(), number(), number()) :: list()
  defp process_chunk(possibility, _coin, 0), do: possibility

  defp process_chunk(possibility, coin, coin_count) do
    stripped = Enum.drop(possibility, coin_count)
    [[generate_coins(coin, coin_count)] | stripped]
  end

  @spec generate_max_result(integer()) :: [integer()]
  defp generate_max_result(change, opts \\ [ignore_equal: false]) do
    raw_result = generate_raw_max_result(change, opts)
    List.flatten(raw_result)
  end

  @spec generate_raw_max_result(integer(), list()) :: [integer()]
  defp generate_raw_max_result(0, _opts), do: nil

  defp generate_raw_max_result(change, opts) do
    ignore_equal = Keyword.get(opts, :ignore_equal, false)
    # Get all the lower coins from the change
    lower_coins = DataProvider.get_lower_coins(change, ignore_equal: ignore_equal)
    # Calculate all the coin values
    highest_coin = List.last(lower_coins)
    coin_count = change / highest_coin
    whole_coins = trunc(coin_count)
    part_coins = coin_count - whole_coins
    # Recurse using the coin calculations
    recurse_coin_result(part_coins, whole_coins, highest_coin)
  end

  @spec recurse_coin_result(number(), number(), number()) :: any()
  defp recurse_coin_result(0.0, whole_coin, highest_coin),
    do: generate_coins(highest_coin, whole_coin)

  defp recurse_coin_result(part_coins, whole_coin, highest_coin) do
    coin_result = round(part_coins * highest_coin)
    [generate_max_result(coin_result) | generate_coins(highest_coin, whole_coin)]
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

  defp strip_lowest_coin([_head | tail]), do: tail

  @spec recurse_periodic_coins(integer(), list()) :: list()
  defp recurse_periodic_coins(change, _) when change <= 0, do: []
  defp recurse_periodic_coins(_, []), do: []

  defp recurse_periodic_coins(change, list) when is_list(list) do
    # Calculate the coin count
    [head | tail] = list
    coin_count = change / head
    decimal_part = coin_count - trunc(coin_count)
    # Generate coins if the coin count is a whole number
    will_generate = abs(decimal_part) < 0.0000001
    coin_res = generate_coins_gate(head, trunc(coin_count), will_generate)
    # Prepend if the coin result is not empty
    will_prepend = not Enum.empty?(coin_res)
    prepend_gate(coin_res, recurse_periodic_coins(change, tail), will_prepend)
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
