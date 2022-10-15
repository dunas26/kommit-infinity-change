IEx.configure(inspect: [charlists: :as_lists])

# result = 25 |> IO.inspect |> InfinityChange.compute_coin_change |> IO.inspect(charlists: :as_lists)
# result |> length |> IO.inspect

# [10, 5] |> IO.inspect |> InfinityChange.calculate_possibilities |> IO.inspect
# val = [[5,10,10], 10]
# [input | _tail]= val
# InfinityChange.append_possibility(val, input)

# [10] |> IO.inspect |> InfinityChange.can_subdivide(1) |> IO.inspect
# [[1,1,1,1,1], [5], [1,1,1,1,1]] |> IO.inspect |> InfinityChange.can_subdivide(1) |> IO.inspect
# [[1,1,1,1,1], [1,1,1,1,1], [10], [5,5]] |> IO.inspect |> InfinityChange.can_subdivide(1) |> IO.inspect

# [] |> IO.inspect(charlists: :as_lists) |> InfinityChange.solve |> IO.inspect(charlists: :as_lists)

# 5 |> IO.inspect(charlists: :as_lists) |> InfinityChange.solve_recursively |> IO.inspect
n = 5
value = [n, InfinityChange.generate_possibilities(n)] |> IO.inspect(charlists: :as_lists)
n = 10
value = [n, InfinityChange.generate_possibilities(n)] |> IO.inspect(charlists: :as_lists)
n = 25
value = [n, InfinityChange.generate_possibilities(n)] |> IO.inspect(charlists: :as_lists)
n = 50
value = [n, InfinityChange.generate_possibilities(n)] |> IO.inspect(charlists: :as_lists)
n = 100
value = [n, InfinityChange.generate_possibilities(n)] |> IO.inspect(charlists: :as_lists)
# 10 |> IO.inspect(charlists: :as_lists) |> InfinityChange.generate_possibilities |> IO.inspect

# 355 |> IO.inspect |> InfinityChange.compute_coin_change |> IO.inspect(charlists: :as_lists)
# 558 |> IO.inspect |> InfinityChange.compute_coin_change |> IO.inspect(charlists: :as_lists)
# 752 |> IO.inspect |> InfinityChange.compute_coin_change |> IO.inspect(charlists: :as_lists)
# 239 |> IO.inspect |> InfinityChange.compute_coin_change |> IO.inspect(charlists: :as_lists)
