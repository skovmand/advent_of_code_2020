defmodule Advent20.Encoding do
  @moduledoc """
  Day 9: Encoding Error
  """

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Part 1: The first step of attacking the weakness in the XMAS data
  is to find the first number in the list (after the preamble) which
  is not the sum of two of the 25 numbers before it. 

  What is the first number that does not have this property?
  """
  def first_failing_number(input, preamble_length) do
    numbers = parse(input)

    Stream.unfold(0, fn
      index ->
        range = index..(index + preamble_length - 1)

        current_number = Enum.at(numbers, index + preamble_length)
        window = Enum.slice(numbers, range)
        {{current_number, window}, index + 1}
    end)
    |> Stream.filter(&number_not_in_window/1)
    |> Enum.find(& &1)
    |> elem(0)
  end

  defp number_not_in_window({current_number, window}) do
    matching_numbers = for a <- window, b <- window, a != b, do: {a, b}

    Enum.find(matching_numbers, fn {a, b} -> a + b == current_number end)
    |> case do
      nil -> current_number
      _ -> false
    end
  end
end
