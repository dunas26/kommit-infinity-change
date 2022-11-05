defmodule InfinityChange do
  alias InfinityChange.Generation
  alias InfinityChange.DataProvider
  alias InfinityChange.Merging
  alias InfinityChange.Compose

  @moduledoc """
  # InfinityChange Documentation

    Compute coin change. This modules computes how many possibilites are there in order to return a coin.

    This is done by computing all the possibilities for the different coin values.
    For instance:

    `[a, [b, c, d]]`

    This data structure is called a base, we have a base when:
    - The total length is 2
    - The first element of the list is a number
    - The second element of the list is a list containing all the possibilities

    This means that **a** can be represented as **b**, **c** or **d**

    After having all possibilities compiled, we scroll to the parsing process where we take all our raw possibility, called a possibility mapping, and parse it into a combinable state like so:

    Let **10** as an input example.

    The possibility map of 10 contains also the possibility map for the number 5 as so:

    `10 -> [10, [[5, [1,1,1,1,1]], [5, 1,1,1,1,1]]]`

    better expressed as:

    ```
    10
    [
      [5, [1,1,1,1,1]],
      [5, [1,1,1,1,1]]
    ]
    ```

    If we were to combine this right away we would end up with ```10,5,1,1,1,1,1``` like so

    When parsing this input we end up with this:

    ```
    10,
    [
      [5,5],
      [5,1,1,1,1,1],
      [1,1,1,1,1,1,1,1,1,1]
    ]
    ```

    This is the result from combining the each index of `[5, [1,1,1,1,1]]` with each index of `[5, [1,1,1,1,1]]`.

    After parsing the possibility map, we are now in a combinable state, where we can combine our base number and our possibilities recursively.

    The final result of this combination is `[10, [5,5], [5,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1]]`

    An extra step is made in order to add missing coins in some cases. It's mainly a repetition of coins that when added together result in the original change.

    Take for example **50**:

    We know that 50 might be straight forward value to represent, but there's a simple catch.

    Subdividing 50 gives as a result `[25, 25]`
    But, when we subdivide 25 we end up with this result `[5, 10, 10]`

    Nothing is wrong with it, but if we add up together both 25s we discover a problem.

    `[5, 10, 10, 5, 10, 10]`

    There is still a 10 that can be added up by joining both 5s together.

    Based on our possibility mapping, this case is unlikely to happen, because 25 only solves to 5, 10, 10, and we can't merge both 25s together during generation.

    So we add up another process to generate this repetition of coins adding effectively the missing possibility.

    ```
    50
    25, 25
    5, 10, 10, 5, 10, 10
    -> 10, 10, 10, 10, 10 # added afterwards
    5, 5, 5, ...
    ```
    and so on.
  """

  @doc """
  This function generate a coin change array an then outputs the result to the STDIN
  """
  @spec present_coin_change(integer()) :: term()
  def present_coin_change(change) do
    coin_change = compute_coin_change(change)
    present_results(change, coin_change)
  end

  @doc """
  Computes any coin change into a resulting array.

  It accepts any possitive integer.

  ## Examples
  ```
  iex> compute_coin_change(1)
  [1]
  iex> compute_coin_change(5)
  [[5], [1,1,1,1,1]]
  iex> compute_coin_change(10)
  [[10], [5,5], [5,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1]]
  ```
  """
  @spec compute_coin_change(integer()) :: [[integer()]]
  def compute_coin_change(change) when change <= 0, do: []

  def compute_coin_change(change) do
    # Generate possibility map
    result = Generation.map_possibilities(change)
    # Get variety
    variety = DataProvider.get_coin_variety(result)
    # Perform a map parsing
    parse_result = Merging.parse(result, variety)
    # We now have a combinable state

    raw_compose_state = Compose.do_compose(parse_result)
    # Optional formatting
    # Generate periodical coins for missing spots
    periodical = Generation.generate_periodical_coins(change)
    # Merge periodical coin states with the compose state
    final_state =
      (periodical ++ raw_compose_state)
      |> Enum.uniq()
      |> Enum.map(&try_flatten(&1))
      |> Enum.sort(&(&1 > &2))

    # Add whole coin change to the top of the output
    if DataProvider.in_coins?(change) and not DataProvider.is_lowest_coin?(change),
      do: [[change] | final_state],
      else: final_state
  end

  @spec try_flatten(list() | number()) :: list()
  defp try_flatten(number) when is_number(number), do: number
  defp try_flatten(list) when is_list(list), do: List.flatten(list)

  @spec try_join(list()) :: String.t()
  defp try_join(list) when is_list(list) do
    Enum.join(list, ", ")
  end

  defp try_join(value), do: "#{value}"

  @spec present_results(integer(), list()) :: term()
  defp present_results(_change, list) do
    Enum.each(list, &IO.puts(try_join(&1)))
  end
end
