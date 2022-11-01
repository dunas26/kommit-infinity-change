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
# n = 5
# IO.write("N: ")
# IO.inspect(n, charlists: :as_lists)
# IO.puts("-------------------------------------")
# value = [n, InfinityChange.generate_possibilities(n)] |> IO.inspect(charlists: :as_lists)
# n = 13
# IO.write("N: ")
# IO.inspect(n, charlists: :as_lists)
# IO.puts("-------------------------------------")
# value = [n, InfinityChange.generate_possibilities(n)] |> IO.inspect(charlists: :as_lists)
# n = 28
# IO.write("N: ")
# IO.inspect(n, charlists: :as_lists)
# IO.puts("-------------------------------------")
# value = [n, InfinityChange.generate_possibilities(n)] |> IO.inspect(charlists: :as_lists)
# n = 59
# IO.write("N: ")
# IO.inspect(n, charlists: :as_lists)
# IO.puts("-------------------------------------")
# value = [n, InfinityChange.generate_possibilities(n)] |> IO.inspect(charlists: :as_lists)
# n = 103
# IO.write("N: ")
# IO.inspect(n, charlists: :as_lists)
# IO.puts("-------------------------------------")
# value = [n, InfinityChange.generate_possibilities(n)] |> IO.inspect(charlists: :as_lists)

# InfinityChange.compute_coin_change(1) # -> [1]
# InfinityChange.compute_coin_change(3) # -> [1,1,1]
# InfinityChange.compute_coin_change(5) # -> [5, [1,1,1,1,1]]
# InfinityChange.compute_coin_change(6) # -> [[1,5], [1,1,1,1,1,1]]
# InfinityChange.compute_coin_change(9)
# InfinityChange.compute_coin_change(5) |> InfinityChange.x # -> [5,[1,1,1,1,1]]
# InfinityChange.compute_coin_change(10) |> InfinityChange.x # -> [10, [5,5], [5,1,1,1,1,1], [1,...,1]]
# InfinityChange.compute_coin_change(25) |> InfinityChange.x # -> [10, [5,5], [5,1,1,1,1,1], [1,...,1]]
# InfinityChange.compute_coin_change(50) |> InfinityChange.x # -> [10, [5,5], [5,1,1,1,1,1], [1,...,1]]
# InfinityChange.compute_coin_change(75) |> InfinityChange.x # -> [10, [5,5], [5,1,1,1,1,1], [1,...,1]]
# InfinityChange.compute_coin_change(100) |> InfinityChange.x # -> [10, [5,5], [5,1,1,1,1,1], [1,...,1]]
# 
# Encapsulating isolated numbers

# InfinityChange.compute_coin_change(6) |> InfinityChange.x # -> [[1],...]
# InfinityChange.compute_coin_change(8) |> InfinityChange.x # -> [[1,1,1],...]
# InfinityChange.compute_coin_change(12) |> InfinityChange.x # -> [[1,1],...]
# InfinityChange.Generation.generate_periodical_coins(5) |> InfinityChange.x("Periodical coins ")
# InfinityChange.Generation.generate_periodical_coins(10) |> InfinityChange.x("Periodical coins ")
# InfinityChange.Generation.generate_periodical_coins(25) |> InfinityChange.x("Periodical coins ")
# InfinityChange.Generation.generate_periodical_coins(50) |> InfinityChange.x("Periodical coins ")
# InfinityChange.Generation.generate_periodical_coins(75) |> InfinityChange.x("Periodical coins ")
# InfinityChange.Generation.generate_periodical_coins(100) |> InfinityChange.x("Periodical coins ")
Enum.to_list(1..50) |> Enum.each(&(&1 |> InfinityChange.compute_coin_change |> InfinityChange.Debugging.x("Compute coin change ")))

# InfinityChange.compute_coin_change(50) |> IO.inspect(label: "Testing sort", charlists: :as_lists)
# InfinityChange.compute_coin_change(1) |> InfinityChange.x("Testing ")
# a = [1,1,1,1,1]
# b = [[5, a], [5,a]]
# InfinityChange.do_combine(a, InfinityChange.get_coin_variety(a)) |> InfinityChange.x("Do combine ") # [1,1,1,1,1]
# InfinityChange.do_combine(b, InfinityChange.get_coin_variety(b)) |> InfinityChange.x("Do combine ") # [[5,5], [5,1,...], [1,...]]
# a = [5, [1,1,1,1,1]]
# b = [10, [a, a]]
# InfinityChange.do_combine(a, InfinityChange.get_coin_variety(a)) |> InfinityChange.x("Do combine ")
# [5, [1,1,1,1,1]]
# InfinityChange.do_combine(b, InfinityChange.get_coin_variety(b)) |> InfinityChange.x("Do combine ")
# [10, [5,5], [5,1,...], [1,...]]

# times = 3
# InfinityChange.can_take?([5, [1,1,1,1,1]]) |> IO.inspect
# InfinityChange.can_take?([10, [[5, [1,1,1,1,1]], [5, [1,1,1,1,1]]]]) |> IO.inspect

# 10 |> IO.inspect(charlists: :as_lists) |> InfinityChange.generate_possibilities |> IO.inspect

# 355 |> IO.inspect |> InfinityChange.compute_coin_change |> IO.inspect(charlists: :as_lists)
# 558 |> IO.inspect |> InfinityChange.compute_coin_change |> IO.inspect(charlists: :as_lists)
# 752 |> IO.inspect |> InfinityChange.compute_coin_change |> IO.inspect(charlists: :as_lists)
# 239 |> IO.inspect |> InfinityChange.compute_coin_change |> IO.inspect(charlists: :as_lists)
