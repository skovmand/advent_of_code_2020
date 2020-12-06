defmodule Advent20.ExpenseReport do
  @moduledoc """
  Day 1: Report Repair
  """

  defp number_set(input_filename) do
    input_filename
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> MapSet.new()
  end

  @doc """
  Part 1: Find two numbers in a set that add up to a sum
  """
  def find_sum_2(input_filename, sum) do
    input_filename
    |> number_set()
    |> find_sum(sum)
  end

  @doc """
  Part 2: Find three numbers in a set that add up to a sum
  """
  def find_sum_3(input_filename, sum) do
    number_set = number_set(input_filename)

    Enum.reduce_while(number_set, nil, fn number_1, nil ->
      remaining_sum = sum - number_1

      number_set
      |> MapSet.delete(number_1)
      |> find_sum(remaining_sum)
      |> case do
        {number_2, number_3} -> {:halt, {number_1, number_2, number_3}}
        nil -> {:cont, nil}
      end
    end)
  end

  # Find the first match of two numbers in a list of numbers that add up to a given sum
  def find_sum(number_set, sum) do
    Enum.reduce_while(number_set, nil, fn number, nil ->
      remaining_sum = sum - number

      number_set
      |> MapSet.delete(number)
      |> MapSet.member?(remaining_sum)
      |> case do
        true -> {:halt, {number, remaining_sum}}
        false -> {:cont, nil}
      end
    end)
  end
end
