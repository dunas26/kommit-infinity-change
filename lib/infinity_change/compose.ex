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
  defp compose(n, _) when is_number(n), do: n

  defp compose(list, coin_variety) when is_base(list) and coin_variety <= 2, do: list

  defp compose(list, _coin_variety) when is_base(list) do
    [b, p] = list
    [b | compose(p, get_coin_variety(p))]
  end

  defp compose([a], coin_variety) when coin_variety <= 2 and is_possibility([a]), do: [a]

  defp compose([h | t], 3) when is_number(h), do: [h | t]

  defp compose(list, 3) when is_possibility(list) do
    merge(list)
  end

  defp compose([a, b], _coin_Variety) when is_possibility([a, b]) do
    merge(compose(a, get_coin_variety(a)), compose(b, get_coin_variety(b)))
  end

  defp compose(list, _coin_variety) when is_possibility(list) do
    [h | t] = list
    merge(compose(h, get_coin_variety(h)), compose(t, get_coin_variety(t)))
  end
end
