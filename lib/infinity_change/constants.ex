defmodule InfinityChange.Constants do
  def values, do: [coins: [1, 5, 10, 25, 50, 100]]

	def get_coins() do
		get(:coins)
	end

  @spec get(atom()) :: term()
  defp get(atom) do
    Keyword.get(values(), atom, nil)
  end

  @spec has_value?(atom()) :: boolean()
  defp has_value?(atom) do
    Keyword.has_key?(values(), atom)
  end
end
