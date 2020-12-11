defmodule Advent20.SeatingSystem do
  @moduledoc """
  Day 11: Seating System
  """

  def parse(input) do
    seats =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        String.codepoints(line)
        |> Enum.with_index()
        |> Enum.into(%{}, fn {codepoints, index} -> {index, codepoints} end)
      end)
      |> Enum.with_index()
      |> Enum.into(%{}, fn {lines, index} -> {index, lines} end)

    %{
      seats: seats,
      max_x: seats[0] |> Map.keys() |> Enum.max(),
      max_y: seats |> Map.keys() |> Enum.max()
    }
  end

  @doc """
  Part 1: Simulate your seating area by applying the seating rules repeatedly
          until no seats change state. How many seats end up occupied?
  """
  def part_1(input) do
    input
    |> parse()
    |> simulate_seating_area(&occupied_adjacent_seat_count/4, 4)
  end

  def simulate_seating_area(seat_data, seat_count_fn, occupied_limit) do
    seat_data
    |> Stream.unfold(&{&1, apply_seating_rules(&1, seat_count_fn, occupied_limit)})
    |> Enum.reduce_while(nil, fn
      %{seats: seats}, %{seats: seats} -> {:halt, seats}
      seat_data, _ -> {:cont, seat_data}
    end)
    |> count_occupied_seats()
  end

  defp count_occupied_seats(seats) do
    seats
    |> Map.values()
    |> Enum.map(&Map.values/1)
    |> Enum.map(fn line -> Enum.count(line, &(&1 == "#")) end)
    |> Enum.sum()
  end

  # Apply one round of seating rules, returning the updated state
  defp apply_seating_rules(seat_data, seat_count_fn, occupied_limit) do
    applied_seats =
      seat_data.seats
      |> Enum.into(%{}, fn {y, row} ->
        updated_row =
          row
          |> Enum.into(%{}, fn
            {x, "."} ->
              {x, "."}

            {x, seat_state} ->
              occupied_seat_count =
                seat_count_fn.(seat_data.seats, {x, y}, seat_data.max_x, seat_data.max_y)

              case {occupied_seat_count, seat_state} do
                {0, "L"} -> {x, "#"}
                {count, "#"} when count >= occupied_limit -> {x, "L"}
                {_, letter} -> {x, letter}
              end
          end)

        {y, updated_row}
      end)

    %{seat_data | seats: applied_seats}
  end

  defp occupied_adjacent_seat_count(seats, coord, max_x, max_y) do
    coord
    |> adjacent_seats_coords(max_x, max_y)
    |> Enum.map(&seat_state(seats, &1))
    |> Enum.count(&(&1 == "#"))
  end

  def seat_state(seats, {x, y}), do: seats |> Map.fetch!(y) |> Map.fetch!(x)

  # Get the adjecent seats from a given position
  def adjacent_seats_coords({seat_x, seat_y}, max_x, max_y) do
    for x <- (seat_x - 1)..(seat_x + 1),
        y <- (seat_y - 1)..(seat_y + 1),
        x >= 0,
        y >= 0,
        x <= max_x,
        y <= max_y,
        {x, y} != {seat_x, seat_y},
        do: {x, y}
  end
end
