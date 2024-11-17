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

  defp parse(input) do
    input
    |> parse_to_number_list()
    |> MapSet.new()
  end

  @doc """
  Part 1: Find two numbers in a set that add up to a sum
  """
  def find_sum_of_2_numbers(input) do
    input
    |> parse()
    |> find_sum_2(2020)
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
  def find_sum_of_3_numbers(input) do
    number_set = parse(input)

    Enum.find_value(number_set, fn number_1 ->
      remaining_sum = 2020 - number_1

      case find_sum_2(number_set, remaining_sum) do
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
