defmodule Advent20.Shuttle do
  @moduledoc """
  Day 13: Shuttle Search
  """

  defp parse(input) do
    [earliest_departure, bus_ids] = String.split(input, "\n", trim: true)

    %{
      earliest_departure: String.to_integer(earliest_departure),
      bus_ids: bus_ids |> String.split(",") |> Enum.reject(&(&1 == "x")) |> Enum.map(&String.to_integer/1)
    }
  end

  @doc """
  Part 1: What is the ID of the earliest bus you can take to the airport
  multiplied by the number of minutes you'll need to wait for that bus?
  """
  def part_1(input) do
    input
    |> parse()
    |> earliest_bus_id_multiplied()
  end

  def earliest_bus_id_multiplied(%{earliest_departure: earliest_departure, bus_ids: bus_ids}) do
    bus_ids
    |> Enum.map(fn id -> {id, id - rem(earliest_departure, id)} end)
    |> Enum.min_by(fn {_id, minutes} -> minutes end)
    |> (fn {id, minutes} -> id * minutes end).()
  end
end
