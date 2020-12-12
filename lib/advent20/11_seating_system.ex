defmodule Advent20.SeatingSystem do
  @moduledoc """
  Day 11: Seating System
  """

  def parse(input) do
    seats =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, all_coordinates ->
        String.codepoints(line)
        |> Enum.with_index()
        |> Enum.reject(fn {char, _} -> char == "." end)
        |> Enum.reduce(all_coordinates, fn {char, x}, all_coordinates ->
          Map.put(all_coordinates, {x, y}, char)
        end)
      end)

    %{
      seats: seats,
      max_x: seats |> Map.keys() |> Enum.max_by(fn {x, _y} -> x end) |> elem(0),
      max_y: seats |> Map.keys() |> Enum.max_by(fn {_x, y} -> y end) |> elem(1)
    }
  end

  @doc """
  Part 1: Simulate your seating area by applying the seating rules repeatedly
          until no seats change state. How many seats end up occupied?
  """
  def part_1(input) do
    input |> parse() |> simulate_seating_area(&occupied_adjacent_seat_count_above_max?/5, 4)
  end

  @doc """
  Part 2: Given the new visibility method and the rule change for occupied seats becoming empty,
          once equilibrium is reached, how many seats end up occupied?
  """
  def part_2(input) do
    input |> parse() |> simulate_seating_area(&occupied_direct_line_seat_count_above_max?/5, 5)
  end

  def simulate_seating_area(seat_data, seat_count_fn, occupied_limit) do
    seat_data
    |> Stream.unfold(&{&1, apply_seating_rules(&1, seat_count_fn, occupied_limit)})
    |> Enum.reduce_while(nil, fn
      %{seats: seats}, %{seats: seats} -> {:halt, seats}
      seat_data, _ -> {:cont, seat_data}
    end)
    |> Enum.count(fn {_coord, state} -> state == "#" end)
  end

  # Apply one round of seating rules, returning the updated state
  defp apply_seating_rules(seat_data, seat_count_fn, occupied_limit) do
    applied_seats =
      seat_data.seats
      |> Enum.into(%{}, fn {{x, y} = coord, value} ->
        case value do
          "L" ->
            anyone_sitting_adjacent? = seat_count_fn.(seat_data.seats, {x, y}, seat_data.max_x, seat_data.max_y, 0)
            if not anyone_sitting_adjacent?, do: {coord, "#"}, else: {coord, "L"}

          "#" ->
            leave_seat? = seat_count_fn.(seat_data.seats, {x, y}, seat_data.max_x, seat_data.max_y, occupied_limit - 1)
            if leave_seat?, do: {coord, "L"}, else: {coord, "#"}
        end
      end)

    %{seat_data | seats: applied_seats}
  end

  # Is the count of guests sitting adjacent to the current coordinate above a given maximum?
  defp occupied_adjacent_seat_count_above_max?(seats, coord, max_x, max_y, maximum) do
    coord
    |> adjacent_seats_coords(max_x, max_y)
    |> Stream.map(&Map.get(seats, &1))
    |> take_while_below_max(maximum)
  end

  # Is the count of guests sitting in line of sight from the current coordinate above a given maximum?
  defp occupied_direct_line_seat_count_above_max?(seats, coord, max_x, max_y, maximum) do
    eight_direction_fns()
    |> Stream.map(fn number_fn ->
      Stream.iterate(coord, number_fn)
      |> Stream.take_while(fn {x, y} -> x >= 0 and y >= 0 and x <= max_x and y <= max_y end)
      |> Stream.drop(1)
      |> Stream.map(&Map.get(seats, &1))
      |> Enum.find(&(&1 in ["L", "#"]))
    end)
    |> take_while_below_max(maximum)
  end

  defp take_while_below_max(seat_state_stream, maximum) do
    Enum.reduce_while(seat_state_stream, 0, fn seat_state, occupied_count ->
      occupied_seat_count =
        case seat_state do
          "#" -> occupied_count + 1
          _ -> occupied_count
        end

      if occupied_seat_count > maximum do
        {:halt, :reached_max}
      else
        {:cont, occupied_seat_count}
      end
    end)
    |> case do
      :reached_max -> true
      _ -> false
    end
  end

  defp eight_direction_fns() do
    [
      fn {x, y} -> {x + 1, y + 1} end,
      fn {x, y} -> {x + 1, y} end,
      fn {x, y} -> {x + 1, y - 1} end,
      fn {x, y} -> {x, y - 1} end,
      fn {x, y} -> {x - 1, y - 1} end,
      fn {x, y} -> {x - 1, y} end,
      fn {x, y} -> {x - 1, y + 1} end,
      fn {x, y} -> {x, y + 1} end
    ]
  end

  defp adjacent_seats_coords({seat_x, seat_y}, max_x, max_y) do
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