defmodule InfinityChange.Constants do
  @moduledoc false

  def values, do: [coins: [1, 5, 10, 25, 50, 100]]

  @doc """
  Returns the list of available coins
  """
  @spec get_coins :: list()
  def get_coins do
    get(:coins)
  end

  @spec get(atom()) :: term()
  defp get(atom) do
    Keyword.get(values(), atom, nil)
  end
end
