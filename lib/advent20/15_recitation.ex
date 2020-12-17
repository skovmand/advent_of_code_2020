defmodule Advent20.Recitation do
  @moduledoc """
  Day 15: Rambunctious Recitation
  """

  defp parse(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Part 1: Given your starting numbers, what will be the 2020th number spoken?
  """
  def solve(input, turn_requested) do
    input
    |> parse()
    |> start_state()
    |> setup_stream()
    |> Enum.find(&(&1.turn == turn_requested - 1))
    |> Map.fetch!(:spoken)
  end

  defp start_state(number_list) do
    {latest_number, numbers_already_used} = List.pop_at(number_list, -1)

    %{
      turn: length(number_list) - 1,
      numbers: numbers_already_used |> Enum.with_index() |> Map.new(),
      spoken: latest_number
    }
  end

  defp setup_stream(start_state) do
    Stream.iterate(start_state, fn %{spoken: spoken, turn: turn, numbers: numbers} = state ->
      next_spoken =
        case Map.get(numbers, spoken) do
          nil -> 0
          number -> turn - number
        end

      %{state | spoken: next_spoken, numbers: Map.put(numbers, spoken, turn), turn: turn + 1}
    end)
  end
end
