defmodule Advent20.Geology do
  @moduledoc """
  Day 3: Toboggan Trajectory
  """

  # stream the geology line by line
  defp geology_stream(input_filename) do
    input_filename
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  @doc """
  Count the trees
  """
  def count_trees(input_filename, {right, down}) do
    geology_stream(input_filename)
    |> Enum.reduce(%{trees: 0, x: 0, y: 0}, fn geology_line, acc ->
      # Line should be counted (it a multiple of down)
      if rem(acc.y, down) == 0 do
        char =
          geology_line
          |> String.codepoints()
          |> Stream.cycle()
          |> Enum.at(acc.x)

        case char do
          "#" -> Map.update!(acc, :trees, fn t -> t + 1 end)
          "." -> acc
        end
        |> Map.update!(:x, fn x -> x + right end)
        |> Map.update!(:y, fn y -> y + 1 end)
      else
        # Line should be skipped (it is not a multiple of down)
        acc
        |> Map.update!(:y, fn y -> y + 1 end)
      end
    end)
    |> Map.fetch!(:trees)
  end

  @doc """
  Calculate the product of tree counts for multiple slopes
  """
  def multiple_slope_tree_count_product(input_filename, slopes) do
    slopes
    |> Stream.map(&count_trees(input_filename, &1))
    |> Enum.reduce(&Kernel.*/2)
  end
end
