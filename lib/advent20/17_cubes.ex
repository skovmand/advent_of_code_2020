defmodule Advent20.Cubes do
  @moduledoc """
  Day 17: Conway Cubes
  """

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, all_coordinates ->
      String.codepoints(line)
      |> Enum.with_index()
      |> Enum.reject(fn {char, _} -> char == "." end)
      |> Enum.reduce(all_coordinates, fn {char, x}, all_coordinates ->
        Map.put(all_coordinates, {x, y, 0}, char)
      end)
    end)
  end

  def part_1(input) do
    input
    |> parse()
    |> stream()
    |> Enum.at(6)
    |> Map.values()
    |> Enum.count(&(&1 == "#"))
  end

  defp stream(coordinates) do
    Stream.iterate(coordinates, fn coordinates ->
      # Get the MapSet of neighbours of every active cube, these are the coordinates we consider
      calculate_neighbours(coordinates)
      |> Enum.map(fn coord ->
        active_neighbours =
          coord
          |> neighbours()
          |> Enum.count(&(Map.get(coordinates, &1, ".") == "#"))

        cube_active? = Map.get(coordinates, coord, ".") == "#"

        new_state =
          case {cube_active?, active_neighbours} do
            {false, 3} -> "#"
            {true, count} when count in [2, 3] -> "#"
            _ -> "."
          end

        {coord, new_state}
      end)
      |> Enum.reject(fn {_coord, value} -> value == "." end)
      |> Enum.into(%{})
    end)
  end

  defp calculate_neighbours(coordinates) do
    coordinates
    |> Map.keys()
    |> Enum.reduce(MapSet.new(), fn coord, acc ->
      coord
      |> neighbours()
      |> MapSet.new()
      |> MapSet.union(acc)
    end)
  end

  defp neighbours({x, y, z}) do
    for cx <- (x - 1)..(x + 1),
        cy <- (y - 1)..(y + 1),
        cz <- (z - 1)..(z + 1),
        {x, y, z} != {cx, cy, cz},
        do: {cx, cy, cz}
  end
end
