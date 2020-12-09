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

  @doc """
  Part 2: What is the encryption weakness in your XMAS-encrypted list of numbers?
  """
  def contigous_set_for_number(input, invalid_number) do
    numbers = parse(input)

    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(&try_find_sum(&1, numbers, invalid_number))
    |> Enum.find(& &1)
  end

  defp try_find_sum(index, numbers, looking_for) do
    prepared_numbers = Enum.drop(numbers, index)

    Enum.reduce_while(prepared_numbers, %{sum: 0, contigous_numbers: []}, fn number, acc ->
      new_sum = number + acc.sum

      cond do
        new_sum > looking_for ->
          {:halt, false}

        new_sum < looking_for ->
          new_acc = %{sum: new_sum, contigous_numbers: [number | acc.contigous_numbers]}
          {:cont, new_acc}

        new_sum == looking_for ->
          all_contigous_numbers = [number | acc.contigous_numbers]
          {:halt, Enum.max(all_contigous_numbers) + Enum.min(all_contigous_numbers)}
      end
    end)
  end
end
