defmodule InfinityChange do
  @moduledoc """
  # InfinityChange Documentation

  Compute coin change. This modules computes how many possibilites are when returning a coin
  """

  @spec compute_coin_change(integer()) :: integer()
  def compute_coin_change(change) when change <= 0 do
    0
  end

  def compute_coin_change(_change) do
		[1]
  end
end
