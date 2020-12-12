defmodule Advent20.SeatingSystem do
  @moduledoc """
  Day 11: Seating System
  """

  def parse(input) do
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
  end

  @doc """
  Part 1: Simulate your seating area by applying the seating rules repeatedly
          until no seats change state. How many seats end up occupied?
  """
  def part_1(input) do
    seats = parse(input)
    adjacent_seats = adjacent_seats(seats)

    simulate_seating_area(seats, adjacent_seats, 4)
  end

  # Make a map of seat coordinate => list of adjacent seat coordinates
  defp adjacent_seats(seats) do
    seat_coordinates = seats |> Map.keys() |> MapSet.new()

    Enum.into(seat_coordinates, %{}, fn coord ->
      connected_seats =
        eight_direction_fns()
        |> Enum.map(fn dir_fn -> dir_fn.(coord) end)
        |> Enum.filter(fn coordinate -> coordinate in seat_coordinates end)

      {coord, connected_seats}
    end)
  end

  @doc """
  Part 2: Given the new visibility method and the rule change for occupied seats becoming empty,
          once equilibrium is reached, how many seats end up occupied?
  """
  def part_2(input) do
    seats = parse(input)
    adjacent_seats = adjacent_seats_by_line_of_sight(seats)

    simulate_seating_area(seats, adjacent_seats, 5)
  end

  # Make a map of seat coordinate => list of adjacent seat coordinates by line of sight
  defp adjacent_seats_by_line_of_sight(seats) do
    seat_coordinates = seats |> Map.keys() |> MapSet.new()

    max_x = seats |> Map.keys() |> Enum.max_by(fn {x, _y} -> x end) |> elem(0)
    max_y = seats |> Map.keys() |> Enum.max_by(fn {_x, y} -> y end) |> elem(1)

    Enum.into(seat_coordinates, %{}, fn coord ->
      connected_seats =
        eight_direction_fns()
        |> Enum.map(fn number_fn ->
          Stream.iterate(coord, number_fn)
          |> Stream.take_while(fn {x, y} -> x >= 0 and y >= 0 and x <= max_x and y <= max_y end)
          |> Stream.drop(1)
          |> Enum.find(fn coordinate -> coordinate in seat_coordinates end)
        end)
        |> Enum.reject(&(&1 == nil))

      {coord, connected_seats}
    end)
  end

  def simulate_seating_area(seat_data, connected_seats, occupied_limit) do
    seat_data
    |> Stream.unfold(&{&1, apply_seating_rules(&1, connected_seats, occupied_limit)})
    |> Enum.reduce_while(nil, fn
      seats, seats -> {:halt, seats}
      seats, _ -> {:cont, seats}
    end)
    |> Enum.count(fn {_coord, state} -> state == "#" end)
  end

  # Apply one round of seating rules, returning the updated state
  defp apply_seating_rules(seats, connected_seats, occupied_limit) do
    seats
    |> Enum.into(%{}, fn {coord, value} ->
      connected_seats = Map.get(connected_seats, coord, [])

      occupied_connected_seats =
        connected_seats
        |> Enum.map(&Map.fetch!(seats, &1))
        |> Enum.count(&(&1 == "#"))

      case {value, occupied_connected_seats} do
        {"L", 0} -> {coord, "#"}
        {"#", occupied_count} when occupied_count > occupied_limit - 1 -> {coord, "L"}
        {state, _} -> {coord, state}
      end
    end)
  end

  # 8 functions for travelling in all directions on the seat map
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
end
