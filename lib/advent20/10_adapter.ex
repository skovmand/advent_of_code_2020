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
  What is the number of 1-jolt differences multiplied by the number of 3-jolt differences?
  """
  def jolt_differences(input) do
    input
    |> parse()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce([], fn [low, high], acc -> [high - low | acc] end)
    |> Enum.frequencies()
    |> product()
  end

  # Sum up the frequencies, and add the computer and the outlet
  defp product(%{1 => ones, 3 => threes}), do: ones * threes

  @doc """
  What is the total number of distinct ways you can arrange the 
  adapters to connect the charging outlet to your device?
  """
  def adapter_combinations(input) do
    input
    |> parse()
    |> combinations()
    |> Enum.max_by(fn {key, _value} -> key end)
    |> elem(1)
  end

  # Count unique combinations of getting from outlet to computer
  defp combinations(joltages) do
    joltages
    |> Enum.drop(1)
    |> Enum.reduce(%{0 => 1}, fn joltage, acc ->
      sum = Map.get(acc, joltage - 1, 0) + Map.get(acc, joltage - 2, 0) + Map.get(acc, joltage - 3, 0)
      Map.put(acc, joltage, sum)
    end)
  end
end
