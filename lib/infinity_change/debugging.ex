defmodule InfinityChange.Debugging do
  @moduledoc false

  @doc """
    Short function that simply prints out a value and puts a label
  """
  @spec x(any(), any()) :: any()
  def x(n, prefix \\ nil)

  def x(n, nil) do
    n |> IO.inspect(charlists: :as_lists)
  end

  def x(n, prefix) do
    n |> IO.inspect(label: prefix, charlists: :as_lists)
  end
end
