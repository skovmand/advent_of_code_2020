defmodule Advent20.LobbyLayout do
  @moduledoc """
  Day 24: Lobby Layout

  Reference for hex coordinate systems:
  https://www.redblobgames.com/grids/hexagons

  I'm using axial coordinates (q, r)
  """

  @directions %{
    e: {1, 0},
    se: {0, 1},
    sw: {-1, 1},
    w: {-1, 0},
    nw: {0, -1},
    ne: {1, -1}
  }

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&parse_directions(&1, []))
  end

  defp parse_directions([], parsed), do: Enum.reverse(parsed)
  defp parse_directions(["s", "e" | tail], parsed), do: parse_directions(tail, [Map.fetch!(@directions, :se) | parsed])
  defp parse_directions(["s", "w" | tail], parsed), do: parse_directions(tail, [Map.fetch!(@directions, :sw) | parsed])
  defp parse_directions(["n", "e" | tail], parsed), do: parse_directions(tail, [Map.fetch!(@directions, :ne) | parsed])
  defp parse_directions(["n", "w" | tail], parsed), do: parse_directions(tail, [Map.fetch!(@directions, :nw) | parsed])
  defp parse_directions(["e" | tail], parsed), do: parse_directions(tail, [Map.fetch!(@directions, :e) | parsed])
  defp parse_directions(["w" | tail], parsed), do: parse_directions(tail, [Map.fetch!(@directions, :w) | parsed])

  @doc """
  Part 1: Go through the renovation crew's list and determine
  which tiles they need to flip. After all of the instructions
  have been followed, how many tiles are left with the black side up?
  """
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&resolve_coordinate/1)
    |> black_tiles()
    |> Enum.count()
  end

  @doc """
  Part 2: How many tiles will be black after 100 days?
  """
  def part_2(input) do
    input
    |> parse()
    |> Enum.map(&resolve_coordinate/1)
    |> black_tiles()
    |> MapSet.new()
    |> Stream.iterate(&step/1)
    |> Enum.at(100)
    |> Enum.count()
  end

  # Follow the directions from the hexagonal, return the final coordinate
  defp resolve_coordinate(directions) do
    Enum.reduce(directions, {0, 0}, fn {dq, dr}, {q, r} -> {q + dq, r + dr} end)
  end

  # Take a list of coordinates, return a list of black tiles
  defp black_tiles(coordinates) do
    coordinates
    |> Enum.frequencies()
    |> Enum.reject(fn {_, frequency} -> rem(frequency, 2) == 0 end)
    |> Enum.map(fn {coord, _freq} -> coord end)
  end

  # Given a MapSet of black coordinates, return the next tile floor version as a new MapSet
  defp step(black_coordinates) do
    candidates = Enum.flat_map(black_coordinates, &neighbours/1) |> MapSet.new() |> MapSet.union(black_coordinates)

    Enum.reduce(candidates, black_coordinates, fn coord, tile_state ->
      current_state = if MapSet.member?(black_coordinates, coord), do: :black, else: :white
      black_tile_neighbours = coord |> neighbours() |> Enum.count(&MapSet.member?(black_coordinates, &1))

      case {current_state, black_tile_neighbours} do
        {:black, count} when count == 0 or count > 2 -> MapSet.delete(tile_state, coord)
        {:white, 2} -> MapSet.put(tile_state, coord)
        _ -> tile_state
      end
    end)
  end

  # Get all neighbours for a MapSet of black coords
  defp neighbours({q, r}), do: @directions |> Map.values() |> Enum.map(fn {dq, dr} -> {q + dq, r + dr} end)
end
