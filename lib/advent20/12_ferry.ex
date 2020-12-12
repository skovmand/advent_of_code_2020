defmodule Advent20.Ferry do
  @moduledoc """
  Rain Risk
  """

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_instruction/1)
  end

  defp parse_instruction("N" <> fields), do: {:vert, String.to_integer(fields)}
  defp parse_instruction("S" <> fields), do: {:vert, -String.to_integer(fields)}
  defp parse_instruction("E" <> fields), do: {:horiz, String.to_integer(fields)}
  defp parse_instruction("W" <> fields), do: {:horiz, -String.to_integer(fields)}
  defp parse_instruction("R" <> degrees), do: {:rotate, String.to_integer(degrees)}
  defp parse_instruction("L" <> degrees), do: {:rotate, -String.to_integer(degrees)}
  defp parse_instruction("F" <> fields), do: {:forward, String.to_integer(fields)}

  @doc """
  Part 1: Figure out where the navigation instructions lead. 
  What is the Manhattan distance between that location and the ship's starting position?
  """
  def part_1(input) do
    input
    |> parse()
    |> Enum.reduce(%{pos: {0, 0}, rot: 90}, &update_boat/2)
    |> manhattan_distance()
  end

  defp update_boat({:vert, fields}, %{pos: {x, y}} = boat), do: %{boat | pos: {x, y + fields}}
  defp update_boat({:horiz, fields}, %{pos: {x, y}} = boat), do: %{boat | pos: {x + fields, y}}
  defp update_boat({:rotate, degrees}, %{rot: rot} = boat), do: %{boat | rot: rem(rot + degrees, 360)}

  defp update_boat({:forward, fields}, %{rot: 0} = boat), do: update_boat({:vert, fields}, boat)

  defp update_boat({:forward, fields}, %{rot: rot} = boat) when rot in [270, -90],
    do: update_boat({:horiz, -fields}, boat)

  defp update_boat({:forward, fields}, %{rot: rot} = boat) when rot in [180, -180],
    do: update_boat({:vert, -fields}, boat)

  defp update_boat({:forward, fields}, %{rot: rot} = boat) when rot in [90, -270],
    do: update_boat({:horiz, fields}, boat)

  defp manhattan_distance(%{pos: {x, y}}), do: abs(x) + abs(y)
end
