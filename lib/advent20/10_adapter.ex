defmodule Advent20.Adapter do
  @moduledoc """
  Day 10: Adapter Array
  """

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
    |> add_outlet_and_computer()
  end

  defp add_outlet_and_computer(jolt_list), do: [0] ++ jolt_list ++ [Enum.max(jolt_list) + 3]

  @doc """
  Part 1: What is the number of 1-jolt differences multiplied by the number of 3-jolt differences?
  """
  def jolt_differences(input) do
    input
    |> parse()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce([], fn [low, high], acc -> [high - low | acc] end)
    |> Enum.frequencies()
    |> (fn %{1 => ones, 3 => threes} -> ones * threes end).()
  end

  @doc """
  Part 2: What is the total number of distinct ways you can arrange the
  adapters to connect the charging outlet to your device?
  """
  def adapter_combinations(input) do
    input
    |> parse()
    |> unique_paths()
    |> Enum.max_by(fn {key, _value} -> key end)
    |> elem(1)
  end

  # Count unique paths from the outlet to the computer.
  #
  # Say we have the joltages 0, 1, 2, 3, 6 (where 0 is the outlet and 6 is the computer).
  # The basic idea is that there is 1 way to get to 0 (this is our initial state).
  # Then, counting upwards, there is also only 1 way to get to 1 (0->1),
  # but there are 2 ways to get to 2 - either `0->1->2` or `0->2`.
  # Let's call the count of ways to get to e.g. joltage 2 `p(2)`. Then `p(2) = p(0) + p(1) = 2`.
  # Then, there are 4 ways to get to 3, `p(3) = p(0) + p(1) + p(2) = 4` and finally
  # `p(6) = p(5) + p(4) + p(3) = 4`. Note that there are 0 to get to 5 or 4, since they don't exist.
  #
  # This way we we can count unique paths by just knowing the initial state, that there is one path to 0
  #
  # Algorithm source: https://www.coursera.org/lecture/discrete-math-and-analyzing-social-graphs/recursive-counting-number-of-paths-bi8b1
  defp unique_paths(joltages) do
    joltages
    |> Enum.drop(1)
    |> Enum.reduce(%{0 => 1}, fn joltage, acc ->
      sum = Map.get(acc, joltage - 1, 0) + Map.get(acc, joltage - 2, 0) + Map.get(acc, joltage - 3, 0)
      Map.put(acc, joltage, sum)
    end)
  end
end
