defmodule InfinityChange.Compose do
  import InfinityChange.Merging, only: [is_base: 1, is_possibility: 1, merge: 1, merge: 2]
  import InfinityChange.DataProvider, only: [get_coin_variety: 1]

  @doc """
  Composes a combinable state into the final result of a coin change.
  """
  def do_compose(list) do
    compose(list, get_coin_variety(list)) |> Enum.uniq()
  end

  defp compose([], _), do: []
  defp compose(number, _) when is_number(number), do: number

  defp compose(list, coin_variety) when is_base(list) and coin_variety <= 2, do: list

  defp compose(list, _coin_variety) when is_base(list) do
    [base, possibilities] = list
    [base | compose(possibilities, get_coin_variety(possibilities))]
  end

  defp compose([single_element], coin_variety)
       when coin_variety <= 2 and is_possibility([single_element]),
       do: [single_element]

  defp compose([head | tail], 3) when is_number(head), do: [head | tail]

  defp compose(list, 3) when is_possibility(list) do
    merge(list)
  end

  defp compose([first, second], _coin_Variety) when is_possibility([first, second]) do
    merge(compose(first, get_coin_variety(first)), compose(second, get_coin_variety(second)))
  end

  defp compose(list, _coin_variety) when is_possibility(list) do
    [head | tail] = list
    merge(compose(head, get_coin_variety(head)), compose(tail, get_coin_variety(tail)))
  end
end
