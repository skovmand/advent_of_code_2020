defmodule Advent20.ExpenseReport do
  @moduledoc """
  Day 1: Report Repair
  """

  defp parse_input_to_number_set(input) do
    input
    |> String.split("\n", trim_whitespace: true)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
    |> MapSet.new()
  end

  def run() do
    input = IO.read(:stdio, :eof)

    {:ok, {first, second}} = find_sum_of_2_numbers(input, 2020)
    IO.puts("Part 1")
    IO.puts("First: #{Integer.to_string(first)}, Second: #{Integer.to_string(second)}, Product: #{first * second}")

    {:ok, {first, second, third}} = find_sum_of_3_numbers(input, 2020)
    IO.puts("Part 2")

    IO.puts(
      "First: #{Integer.to_string(first)}, Second: #{Integer.to_string(second)}, Third: #{Integer.to_string(third)}, Product: #{first * second * third}"
    )
  end

  @doc """
  Part 1: Find two numbers in a set that add up to a sum
  """
  def find_sum_of_2_numbers(input, sum) do
    input
    |> parse_input_to_number_set()
    |> find_sum_2(sum)
  end

  # Find the first match of two numbers in a list of numbers that add up to a given sum
  def find_sum_2(number_set, sum) do
    do_find_sum_2(MapSet.to_list(number_set), number_set, sum)
  end

  defp do_find_sum_2([], _, _), do: :error

  defp do_find_sum_2([current_number | rest], number_set, sum_to_find) do
    remaining_sum = sum_to_find - current_number

    case MapSet.member?(number_set, remaining_sum) do
      true -> {:ok, {current_number, remaining_sum}}
      false -> do_find_sum_2(rest, number_set, sum_to_find)
    end
  end

  @doc """
  Part 2: Find three numbers in a set that add up to a sum
  """
  def find_sum_of_3_numbers(input, sum) do
    number_set = parse_input_to_number_set(input)

    Enum.find_value(number_set, fn number_1 ->
      remaining_sum = sum - number_1

      case find_sum_2(MapSet.delete(number_set, number_1), remaining_sum) do
        {:ok, {number_2, number_3}} -> {:ok, {number_1, number_2, number_3}}
        :error -> false
      end
    end)
    |> case do
      nil -> :error
      result -> result
    end
  end
end
