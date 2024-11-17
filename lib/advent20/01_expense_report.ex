defmodule Advent20.ExpenseReport do
  @moduledoc """
  Day 1: Report Repair
  """

  import Advent20.Util

  @doc """
  Run using `cat input_files/01_expense_report.txt | mix run -e "Advent20.ExpenseReport.run()"`
  """
  def run() do
    input = read_from_stdin()

    {:ok, {first, second}} = find_sum_of_2_numbers(input)
    print_solution(1, 1, "First: #{first}, Second: #{second}, Product: #{first * second}")

    {:ok, {first, second, third}} = find_sum_of_3_numbers(input)
    print_solution(1, 2, "First: #{first}, Second: #{second}, Third: #{third}, Product: #{first * second * third}")
  end

  @doc """
  Part 1: Find 2 numbers in the text input that add up to 2020
  """
  def find_sum_of_2_numbers(input) do
    number_list = parse_to_number_list(input)

    # To only generate this set once
    number_set = MapSet.new(number_list)

    find_sum_2(number_list, number_set, 2020)
  end

  @doc """
  Find the first match of two numbers in a list of numbers that add up to a given sum
  """
  def find_sum_2([], _, _), do: :error

  def find_sum_2([n | rest], set, sum) do
    remaining_sum = sum - n

    if remaining_sum > 0 and MapSet.member?(set, remaining_sum) do
      {:ok, {n, remaining_sum}}
    else
      find_sum_2(rest, set, sum)
    end
  end

  @doc """
  Part 2: Find 3 numbers in the text input that add up to 2020
  """
  def find_sum_of_3_numbers(input) do
    number_list = parse_to_number_list(input)
    number_set = number_list |> MapSet.new()

    find_sum_3(number_list, number_set, 2020)
  end

  def find_sum_3(number_list, number_set, sum) do
    Enum.find_value(number_set, fn number_1 ->
      remaining_sum = sum - number_1

      case find_sum_2(number_list, number_set, remaining_sum) do
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
