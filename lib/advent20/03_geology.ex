defmodule Advent20.Geology do
  @moduledoc """
  Day 3: Toboggan Trajectory
  """

  @doc """
  Count the trees
  """
  def count_trees(geology_stream, {right, down}) do
    geology_stream
    |> Enum.reduce(%{trees: 0, open: 0, right: 0, down: 0}, fn geology_line, acc ->
      char =
        geology_line
        |> String.codepoints()
        |> Stream.cycle()
        |> Enum.at(acc.right)

      case char do
        "#" -> Map.update!(acc, :trees, fn t -> t + 1 end)
        "." -> Map.update!(acc, :open, fn o -> o + 1 end)
      end
      |> Map.update!(:right, fn r -> r + right end)
      |> Map.update!(:down, fn d -> d + down end)
    end)
    |> Map.fetch!(:trees)
  end
end
