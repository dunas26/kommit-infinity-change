defmodule InfinityChange.DataProvider do
  @moduledoc false

  alias InfinityChange.Constants, as: Const

  @doc """
    Retrieves all defined coins
  """
  @spec get_coins :: list()
  def get_coins, do: Const.get_coins()

  @doc """
    Return all coins that are lower than our given coin.

    ## Examples
    iex> get_lower_coins(5)
    [1, 5]
    iex> get_lower_coins(5, ignore_equal: true)
    [1]
    iex> get_lower_coins(25)
    [1, 5, 10, 25]
    iex> get_lower_coins(25, ignore_equal: true)
    [1, 5, 10]
  """
  @spec get_lower_coins(integer(), list()) :: [integer()]
  def get_lower_coins(value, opts \\ [ignore_equal: false])

  def get_lower_coins(number, opts) do
    ignore_equal = Keyword.get(opts, :ignore_equal, false)

    Enum.filter(
      Const.get_coins(),
      fn
        coin when ignore_equal -> coin < number
        coin -> coin <= number
      end
    )
  end

  @doc """
    Flattens a list of coins and counts all distinct coins
  """
  @spec get_coin_variety(list() | integer()) :: integer()
  def get_coin_variety([]), do: 0

  def get_coin_variety(list) when is_list(list) do
    list
    |> List.flatten()
    |> Enum.max()
    |> get_coin_variety()
  end

  def get_coin_variety(number) when is_number(number) do
    number
    |> get_lower_coins()
    |> length
  end

  @doc """
    Is the given coin the lowest?

    ## Examples
    ```
    iex> Const.get_coins()
    [1, 5, 10, 25, 50, 100]
    iex> is_lowest_coin?(5)
    false
    iex> is_lowest_coin?(1)
    true
    ```
  """
  @spec is_lowest_coin?(integer()) :: boolean()
  def is_lowest_coin?(number) when is_number(number) do
    [lowest_coin | _coins] = Const.get_coins()
    number == lowest_coin
  end

  @doc """
    Is the given integer part of the existing coins?
  """
  @spec in_coins?(integer()) :: boolean()
  def in_coins?(number) when is_number(number) do
    number in Const.get_coins()
  end

  @doc """
    Can I subdivide the current list into smaller parts?

    ## Examples
    ```
    iex> can_subdivide?([5])
    true
    iex> can_subdivide?([5, [1,1,1,1,1]])
    true
    iex> can_subdivide?([1,1,1,1,1])
    false
    ```
  """
  @spec can_subdivide?(list() | number()) :: boolean()
  def can_subdivide?([]), do: false

  def can_subdivide?(list) when is_list(list) do
    list
    |> List.flatten()
    |> Enum.max()
    |> can_subdivide?()
  end

  def can_subdivide?(number) when is_number(number) do
    lower_coins = get_lower_coins(number)
    length(lower_coins) >= 2
  end
end
