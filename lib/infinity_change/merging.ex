defmodule InfinityChange.Merging do
  alias InfinityChange.DataProvider

  @doc """
    Is the input a possibility?

    A possibility is one that:
    - Is a list
    - Has any length
  """
  defguard is_possibility(l) when is_list(l)

  @doc """
    Is the input a base?

    A base is one that:
    - Is a list
    - Has a length of 2
    - It's first element is an integer
  """
  defguard is_base(l) when length(l) == 2 and is_number(hd(l))

  @doc """
    Parses a possibility map into a combinable state.
  """
  @spec parse(list(), integer()) :: list()
  def parse(list, 2) when is_base(list), do: list

  def parse(list, 3) when is_base(list) do
    [b, p] = list
    [b | merge(p)]
  end

  def parse(list, _coin_variety) when is_base(list) do
    [b, p] = list
    [b, parse(p, DataProvider.get_coin_variety(p))]
  end

  def parse(list, coin_variety) when coin_variety <= 1 and is_possibility(list), do: list

  def parse(list, _coin_variety) when is_possibility(list) do
    [h | t] = list
    hv = DataProvider.get_coin_variety(h)
    tv = DataProvider.get_coin_variety(t)
    [parse(h, hv) | parse(t, tv)]
  end

  def parse([], _), do: []

  def parse(n, coin_variety) when coin_variety <= 1, do: n

  @doc """
    Merges a list of list into a single list that contains all possibilities between all of the inputted lists
  """
  @spec merge(list()) :: list()
  def merge(list) when length(list) <= 1, do: list

  def merge(list) when length(list) == 2 do
    [x, y] = list
    merge(x, y) |> Enum.uniq()
  end

  def merge(list) when length(list) > 2 do
    [h | t] = list
    merge(h, merge(t)) |> Enum.uniq()
  end

  @spec merge(list(), list()) :: list()
  def merge(a, b) do
    for x <- a, y <- b, do: [x, y] |> List.flatten() |> Enum.sort()
  end
end
