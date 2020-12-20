defmodule Advent20.Jigsaw do
  @moduledoc """
  Day 20: Jurassic Jigsaw
  """

  defp parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.into(%{}, fn jigsaw ->
      [heading | tiles] = String.split(jigsaw, "\n", trim: true)
      tile_no = Regex.run(~r/^Tile (\d+):/, heading, capture: :all_but_first) |> List.first() |> String.to_integer()

      {tile_no, Enum.map(tiles, &String.codepoints/1)}
    end)
  end

  def part_1(input) do
    tiles = input |> parse()
    all_tile_edges = tiles |> Enum.into(%{}, fn {tile_id, tile} -> {tile_id, edges(tile)} end)

    tiles
    |> Map.keys()
    |> Enum.map(fn tile_id ->
      other_tile_edges = all_tile_edges |> Map.delete(tile_id) |> Enum.flat_map(fn {_id, values} -> values end)

      # Find the count of edges that are present in other maps
      # We have to both check the reversed and non-reversed since the image can be flipped
      common_edge_count =
        all_tile_edges
        |> Map.fetch!(tile_id)
        |> Enum.count(fn edge -> Enum.reverse(edge) in other_tile_edges or edge in other_tile_edges end)

      {tile_id, common_edge_count}
    end)
    |> Enum.filter(fn {_, common_edge_count} -> common_edge_count == 2 end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(&Kernel.*/2)
  end

  # Flip a tile diagonally (switch rows and columns)
  def diagonal_flip(tile), do: tile |> Enum.zip() |> Enum.map(&Tuple.to_list/1)

  # Rotate a tile counterclockwise
  def rotate_left(tile, times \\ 1)
  def rotate_left(tile, 0), do: tile

  def rotate_left(tile, times) do
    rotated = tile |> Enum.map(&Enum.reverse/1) |> diagonal_flip()
    rotate_left(rotated, times - 1)
  end

  # Get the edges of a tile. Note that we always read horizontal
  def edges(tile) do
    0..3
    |> Enum.map(&rotate_left(tile, &1))
    |> Enum.map(&List.first/1)
  end
end
