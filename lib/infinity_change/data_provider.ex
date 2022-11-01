defmodule InfinityChange.DataProvider do
  alias InfinityChange.Constants, as: Const

  @doc """
    Retrieves all defined coins
  """
  @spec get_coins() :: list()
  def get_coins(), do: Const.get_coins()

  @doc """
    Return all coins that are lower than our given coin
  """
  @spec get_lower_coins(integer(), list()) :: [integer()]
  def get_lower_coins(value, opts \\ [ignore_equal: false])

  def get_lower_coins(value, opts) do
    ignore_equal = Keyword.get(opts, :ignore_equal, false)

    Enum.filter(
      Const.get_coins(),
      fn
        x when ignore_equal -> x < value
        x -> x <= value
      end
    )
  end

  @doc """
    Flattens a list of coins and counts all distinct coins
  """
  @spec get_coin_variety(list() | integer()) :: integer()
  def get_coin_variety([]), do: 0

  def get_coin_variety(list) when is_list(list) do
    max = list |> List.flatten() |> Enum.max()
    get_coin_variety(max)
  end

  def get_coin_variety(n) when is_number(n) do
    get_lower_coins(n) |> length
  end

  @doc """
    Is the given coin the lowest?
  """
  @spec is_lowest_coin?(integer()) :: boolean()
  def is_lowest_coin?(n) when is_number(n) do
    [l_coin | _coins] = Const.get_coins()
    n == l_coin
  end

  @doc """
    Is the given integer part of the existing coins?
  """
  @spec in_coins?(integer()) :: boolean()
  def in_coins?(n) when is_number(n) do
    Const.get_coins() |> Enum.member?(n)
  end

  @doc """
    Can I subdivide the current list into smaller parts?
    
    ## Examples
    
    iex> can_subdivide?([5])
    true
    iex> can_subdivide?([5, [1,1,1,1,1]])
    true
    iex> can_subdivide?([1,1,1,1,1])
    false
  """
  @spec can_subdivide?(list() | number()) :: boolean()
  def can_subdivide?([]), do: false

  def can_subdivide?(list) when is_list(list) do
    max = list |> List.flatten() |> Enum.max()
    can_subdivide?(max)
  end

  def can_subdivide?(n) when is_number(n) do
    get_lower_coins(n) |> length >= 2
  end
end
