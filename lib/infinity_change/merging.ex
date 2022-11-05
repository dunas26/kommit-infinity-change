defmodule InfinityChange.Merging do
  alias InfinityChange.DataProvider

  @doc """
    Is the input a possibility?

    A possibility is one that:
    - Is a list
    - Has any length
  """
  defguard is_possibility(list) when is_list(list)

  @doc """
    Is the input a base?

    A base is one that:
    - Is a list
    - Has a length of 2
    - It's first element is an integer
  """
  defguard is_base(list) when length(list) == 2 and is_number(hd(list))

  @doc """
    Parses a possibility map into a combinable state.
  """
  @spec parse(list(), integer()) :: list()
  def parse(list, 2) when is_base(list), do: list

  def parse(list, 3) when is_base(list) do
    [base, possibility] = list
    [base | merge(possibility)]
  end

  def parse(list, _coin_variety) when is_base(list) do
    [base, possibility] = list
    [base, parse(possibility, DataProvider.get_coin_variety(possibility))]
  end

  def parse(list, coin_variety) when coin_variety <= 1 and is_possibility(list), do: list

  def parse(list, _coin_variety) when is_possibility(list) do
    [head | tail] = list
    head_variety = DataProvider.get_coin_variety(head)
    tail_variety = DataProvider.get_coin_variety(tail)
    [parse(head, head_variety) | parse(tail, tail_variety)]
  end

  def parse([], _), do: []

  def parse(number, coin_variety) when coin_variety <= 1, do: number

  @doc """
    Merges a list of list into a single list that contains all possibilities between all of the inputted lists
  """
  @spec merge(list()) :: list()
  def merge(list) when length(list) <= 1, do: list

  def merge(list) when length(list) == 2 do
    [first, second] = list
    merge_result = merge(first, second)
    Enum.uniq(merge_result)
  end

  def merge(list) when length(list) > 2 do
    [head | tail] = list
    merge_result = merge(head, merge(tail))
    Enum.uniq(merge_result)
  end

  @spec merge(list(), list()) :: list()
  def merge(first_src, second_src) do
    for first <- first_src,
        second <- second_src,
        do:
          [first, second]
          |> List.flatten()
          |> Enum.sort()
  end
end
