defmodule Advent20.Jigsaw do
  @moduledoc """
  Day 20: Jurassic Jigsaw
  """

  @sea_monster """
                    # 
  #    ##    ##    ###
   #  #  #  #  #  #   
  """

  def sea_monster() do
    @sea_monster
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.reject(&(&1 == []))
  end

  def all_sea_monsters() do
    sea_monster()
    |> all_rotations()
    |> Enum.map(&sea_monster_coords/1)
  end

  # Move sea monsters relative to a coordinate
  def transpose_sea_monsters(sea_monsters, {x, y}) do
    sea_monsters
    |> Enum.map(fn monster_coords ->
      Enum.map(monster_coords, fn {mx, my} -> {mx + x, my + y} end)
    end)
  end

  def sea_monster_coords(sea_monster) do
    sea_monster
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> Enum.with_index()
      |> Enum.reject(fn {char, _index} -> char == " " end)
      |> Enum.map(&{elem(&1, 1), y})
    end)
  end

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

  def horiz_flip(tile), do: Enum.map(tile, &Enum.reverse/1)
  def vert_flip(tile), do: Enum.reverse(tile)

  # Get the edges of a tile. Note that we always read horizontally from the top, left to right.
  def edges(tile) do
    0..3
    |> Enum.map(&rotate_left(tile, &1))
    |> Enum.map(&List.first/1)
  end

  # Get all rotations and flips for a tile.
  def all_rotations(tile) do
    normal_tiles =
      0..3
      |> Enum.map(&rotate_left(tile, &1))

    reversed_tile = tile |> Enum.map(&Enum.reverse/1)

    other_reversed_tiles =
      1..3
      |> Enum.map(&rotate_left(reversed_tile, &1))

    normal_tiles ++ [reversed_tile] ++ other_reversed_tiles
  end

  def part_2(input) do
    tiles = input |> parse()
    all_tile_forms = tiles |> Enum.into(%{}, fn {tile_id, tile} -> {tile_id, all_rotations(tile)} end)

    initial_tile_id = tiles |> Map.keys() |> List.first()

    # We place the initial tile at 100, 100
    # just to avoid having to deal with negative numbers
    image = %{
      {100, 100} => Map.fetch!(tiles, initial_tile_id)
    }

    image =
      place_tiles(image, all_tile_forms, MapSet.new([initial_tile_id]), MapSet.new([{100, 100}]))
      |> to_full_image()

    coordinate_system = to_coordinate_system(image)
    max_x = coordinate_system |> Map.keys() |> Enum.max_by(fn {x, _y} -> x end) |> elem(0)
    max_y = coordinate_system |> Map.keys() |> Enum.max_by(fn {_x, y} -> y end) |> elem(1)

    sea_monsters = all_sea_monsters()
    coordinates = for x <- 0..max_x, y <- 0..max_y, do: {x, y}

    monster_fields =
      Enum.reduce(coordinates, MapSet.new(), fn coordinate, acc ->
        transposed_sea_monsters = transpose_sea_monsters(sea_monsters, coordinate)

        transposed_sea_monsters
        |> Enum.reduce(acc, fn monster_coords, acc ->
          if Enum.all?(monster_coords, fn coord -> Map.get(coordinate_system, coord) == "#" end) do
            MapSet.union(acc, MapSet.new(monster_coords))
          else
            acc
          end
        end)
      end)
      |> Enum.count()

    rough_waters = Enum.count(coordinate_system, fn {_coord, val} -> val == "#" end) - monster_fields
  end

  # Convert the final puzzle image into a coordinate system
  defp to_coordinate_system(image) do
    image
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      line
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, acc ->
        Map.put(acc, {x, y}, char)
      end)
    end)
  end

  # Convert the map of tiles into a full image
  defp to_full_image(tile_map) do
    tile_map
    |> Enum.map(fn {coord, tile} ->
      cut_tile =
        tile
        |> Enum.drop(1)
        |> Enum.take(8)
        |> Enum.map(fn line -> line |> Enum.drop(1) |> Enum.take(8) |> Enum.join() end)

      {coord, cut_tile}
    end)
    |> Enum.group_by(fn {{_x, y}, _tile} -> y end, fn {{x, _y}, tile} -> {x, tile} end)
    |> Enum.into(%{}, fn {y, row} ->
      updated_row =
        row
        |> Enum.sort_by(fn {x, _column} -> x end)
        |> Enum.map(&elem(&1, 1))
        |> Enum.zip()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(&Enum.join(&1, ""))
        |> Enum.join("\n")

      {y, updated_row}
    end)
    |> Enum.sort_by(fn {y, _row} -> -y end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.join("\n")
  end

  # Place tiles. Must be called with updated visited
  defp place_tiles(image, tiles, placed_tiles, visited) do
    image_keys = Map.keys(image)
    tile_keys = Map.keys(tiles)

    # All tiles are placed
    if length(image_keys) == length(tile_keys) do
      image
    else
      # Only consider new fields
      neighbours = image_keys |> calculate_neighbours() |> MapSet.new()
      new_neighbours = MapSet.difference(neighbours, visited)

      state =
        new_neighbours
        |> Enum.reduce(%{image: image, visited: visited, placed_tiles: placed_tiles}, fn coord, state ->
          {ref_coord, ref_tile} = find_reference_tile!(state.image, coord)

          {comparison_edge_label, own_edge_label} = ref_coord |> which_edge(coord)

          comparison_edge = comparison_edge_label |> get_edge(ref_tile) |> Enum.reverse()

          tile_search_result =
            tiles
            |> Stream.reject(fn {tile_id, _} -> tile_id in state.placed_tiles end)
            |> Enum.flat_map(fn {tile_id, tile_rotations} ->
              tile_rotations
              |> Enum.flat_map(fn tile_rotation ->
                relevant_edge = get_edge(own_edge_label, tile_rotation)

                if relevant_edge == comparison_edge do
                  [{tile_id, tile_rotation}]
                else
                  []
                end
              end)
            end)

          case tile_search_result do
            [] ->
              %{state | visited: MapSet.put(visited, coord)}

            [{tile_id, tile_rotation}] ->
              %{
                state
                | visited: MapSet.put(state.visited, coord),
                  image: Map.put(state.image, coord, tile_rotation),
                  placed_tiles: MapSet.put(state.placed_tiles, tile_id)
              }
          end
        end)

      place_tiles(state.image, tiles, state.placed_tiles, state.visited)
    end
  end

  # For a given coordinate, find a filled neighbour tile
  defp find_reference_tile!(image, coord) do
    coord
    |> neighbours()
    |> Enum.find_value(fn coord ->
      case Map.get(image, coord) do
        nil -> nil
        tile -> {coord, tile}
      end
    end)
  end

  defp get_edge(:top, tile), do: tile |> List.first()
  defp get_edge(:right, tile), do: tile |> rotate_left(1) |> List.first()
  defp get_edge(:bottom, tile), do: tile |> rotate_left(2) |> List.first()
  defp get_edge(:left, tile), do: tile |> rotate_left(3) |> List.first()

  # Which edge of the source should we compare to, given the current coordinate?
  defp which_edge({sx, sy}, {cx, cy}) do
    case {cx - sx, cy - sy} do
      {-1, 0} -> {:left, :right}
      {1, 0} -> {:right, :left}
      {0, 1} -> {:top, :bottom}
      {0, -1} -> {:bottom, :top}
    end
  end

  defp calculate_neighbours(coord_list) do
    Enum.flat_map(coord_list, &neighbours/1)
    |> Enum.uniq()
  end

  defp neighbours({x, y}), do: [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
end
