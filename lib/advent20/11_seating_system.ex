defmodule Advent20.SeatingSystem do
  @moduledoc """
  Day 11: Seating System
  """

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
  end

  @doc """
  Part 1: Simulate your seating area by applying the seating rules repeatedly
          until no seats change state. How many seats end up occupied?
  """
  def simulate_seating_area(input) do
    seating_area = parse(input)
    coordinates = coordinates(seating_area)

    seating_area
    |> Stream.unfold(fn seating_area -> {seating_area, apply_seating_rules(seating_area, coordinates)} end)
    |> Enum.reduce_while(nil, fn
      seating_area, seating_area -> {:halt, seating_area}
      seating_area, _ -> {:cont, seating_area}
    end)
    |> count_occupied_seats()
  end

  defp coordinates(seating_area) do
    max_x = seating_area |> Enum.at(0) |> length() |> Kernel.-(1)
    max_y = seating_area |> length() |> Kernel.-(1)
    for x <- 0..max_x, y <- 0..max_y, do: {x, y}
  end

  defp count_occupied_seats(state) do
    state |> Enum.map(fn list -> Enum.count(list, fn c -> c == "#" end) end) |> Enum.sum()
  end

  # Apply one round of seating rules, returning the updated state
  defp apply_seating_rules(original_state, coordinates) do
    coordinates
    |> Enum.reduce(original_state, fn coord, state ->
      seat_state = seat_state(original_state, coord)
      occupied_seat_count = occupied_adjacent_seat_count(original_state, coord)
      apply_seating_rule(state, coord, seat_state, occupied_seat_count)
    end)
  end

  defp apply_seating_rule(state, coord, "L", occupied_seat_count) when occupied_seat_count == 0,
    do: update_state(state, coord, "#")

  defp apply_seating_rule(state, coord, "#", occupied_seat_count) when occupied_seat_count >= 4,
    do: update_state(state, coord, "L")

  defp apply_seating_rule(state, _, _, _), do: state

  defp occupied_adjacent_seat_count(state, coord) do
    state
    |> adjacent_seats_coords(coord)
    |> Enum.map(&seat_state(state, &1))
    |> Enum.count(&(&1 == "#"))
  end

  # Get the state of the seat at x, y as either :empty, :occupied or :floor
  # x is the horizontal position from the left starting at 0,
  # y is the vertical position from the top starting at 0
  def seat_state(state, {x, y}) do
    state |> Enum.at(y) |> Enum.at(x)
  end

  # Update the seat state at {x, y}
  def update_state(state, {x, y}, seat_state) when seat_state in ["L", "#"] do
    state
    |> List.update_at(y, fn row ->
      List.update_at(row, x, fn _ -> seat_state end)
    end)
  end

  # Get the adjecent seats from a given position
  def adjacent_seats_coords(state, {seat_x, seat_y}) do
    max_x = state |> Enum.at(0) |> length() |> Kernel.-(1)
    max_y = state |> length() |> Kernel.-(1)

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
