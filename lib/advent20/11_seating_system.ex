defmodule Advent20.SeatingSystem do
  @moduledoc """
  Day 11: Seating System
  """

  def parse(input) do
    seats =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.codepoints/1)

    max_x = seats |> List.first() |> length() |> Kernel.-(1)
    max_y = length(seats) - 1

    %{
      seats: seats,
      max_x: max_x,
      max_y: max_y
    }
  end

  @doc """
  Part 1: Simulate your seating area by applying the seating rules repeatedly
          until no seats change state. How many seats end up occupied?
  """
  def simulate_seating_area(input) do
    seat_data = parse(input)

    seat_data
    |> Stream.unfold(&{&1, apply_seating_rules(&1)})
    |> Enum.reduce_while(nil, fn
      %{seats: seats}, %{seats: seats} -> {:halt, seats}
      seat_data, _ -> {:cont, seat_data}
    end)
    |> count_occupied_seats()
  end

  defp count_occupied_seats(seats) do
    seats
    |> Enum.map(fn line -> Enum.count(line, &(&1 == "#")) end)
    |> Enum.sum()
  end

  # Apply one round of seating rules, returning the updated state
  defp apply_seating_rules(seat_data) do
    applied_seats =
      seat_data.seats
      |> Stream.with_index()
      |> Stream.map(fn {row, y} ->
        row
        |> Stream.with_index()
        |> Stream.map(fn
          {".", _} ->
            "."

          {seat_state, x} ->
            occupied_seat_count =
              occupied_adjacent_seat_count(seat_data.seats, {x, y}, seat_data.max_x, seat_data.max_y)

            case {occupied_seat_count, seat_state} do
              {0, "L"} -> "#"
              {count, "#"} when count >= 4 -> "L"
              {_, letter} -> letter
            end
        end)
        |> Enum.map(& &1)
      end)
      |> Enum.map(& &1)

    %{seat_data | seats: applied_seats}
  end

  defp occupied_adjacent_seat_count(seats, coord, max_x, max_y) do
    coord
    |> adjacent_seats_coords(max_x, max_y)
    |> Enum.map(&seat_state(seats, &1))
    |> Enum.count(&(&1 == "#"))
  end

  def seat_state(seats, {x, y}), do: seats |> Enum.at(y) |> Enum.at(x)

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
