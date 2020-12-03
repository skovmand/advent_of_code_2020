defmodule Advent20.Geology do
  @moduledoc """
  Day 3: Toboggan Trajectory
  """

  @doc """
  Count the trees
  """
  def count_trees(geology_stream, {right, down}) do
    geology_stream
    |> Enum.reduce(%{trees: 0, open: 0, x: 0, y: 0}, fn geology_line, acc ->
      # Line should be counted
      if rem(acc.y, down) == 0 do
        char =
          geology_line
          |> String.codepoints()
          |> Stream.cycle()
          |> Enum.at(acc.x)

        case char do
          "#" -> Map.update!(acc, :trees, fn t -> t + 1 end)
          "." -> Map.update!(acc, :open, fn o -> o + 1 end)
        end
        |> Map.update!(:x, fn x -> x + right end)
        |> Map.update!(:y, fn y -> y + 1 end)
      else
        # Line should be skipped
        acc
        |> Map.update!(:y, fn y -> y + 1 end)
      end
    end)
    |> Map.fetch!(:trees)
  end
end
