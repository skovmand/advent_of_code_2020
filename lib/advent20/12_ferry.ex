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
    |> Enum.reduce(%{ship_pos: {0, 0}, rot: 90}, &update_boat/2)
    |> manhattan_distance()
  end

  defp update_boat({:vert, fields}, %{ship_pos: {x, y}} = boat), do: %{boat | ship_pos: {x, y + fields}}
  defp update_boat({:horiz, fields}, %{ship_pos: {x, y}} = boat), do: %{boat | ship_pos: {x + fields, y}}
  defp update_boat({:rotate, degrees}, %{rot: rot} = boat), do: %{boat | rot: rem(rot + degrees, 360)}

  defp update_boat({:forward, fields}, %{rot: 0} = boat), do: update_boat({:vert, fields}, boat)

  defp update_boat({:forward, fields}, %{rot: rot} = boat) when rot in [270, -90],
    do: update_boat({:horiz, -fields}, boat)

  defp update_boat({:forward, fields}, %{rot: rot} = boat) when rot in [180, -180],
    do: update_boat({:vert, -fields}, boat)

  defp update_boat({:forward, fields}, %{rot: rot} = boat) when rot in [90, -270],
    do: update_boat({:horiz, fields}, boat)

  defp manhattan_distance(%{ship_pos: {x, y}}), do: abs(x) + abs(y)

  @doc """
  Part 2: Figure out where the navigation instructions actually lead.
  What is the Manhattan distance between that location and the ship's starting position?
  """
  def part_2(input) do
    input
    |> parse()
    |> Enum.reduce(%{ship_pos: {0, 0}, waypoint_pos: {10, 1}}, &update_state/2)
    |> manhattan_distance()
  end

  defp update_state({:vert, fields}, %{waypoint_pos: {x, y}} = state), do: %{state | waypoint_pos: {x, y + fields}}
  defp update_state({:horiz, fields}, %{waypoint_pos: {x, y}} = state), do: %{state | waypoint_pos: {x + fields, y}}

  defp update_state({:rotate, 90}, %{waypoint_pos: {x, y}} = state), do: %{state | waypoint_pos: {y, -x}}
  defp update_state({:rotate, 180}, %{waypoint_pos: {x, y}} = state), do: %{state | waypoint_pos: {-x, -y}}
  defp update_state({:rotate, 270}, %{waypoint_pos: {x, y}} = state), do: %{state | waypoint_pos: {-y, x}}
  defp update_state({:rotate, -90}, %{waypoint_pos: {x, y}} = state), do: %{state | waypoint_pos: {-y, x}}
  defp update_state({:rotate, -180}, %{waypoint_pos: {x, y}} = state), do: %{state | waypoint_pos: {-x, -y}}
  defp update_state({:rotate, -270}, %{waypoint_pos: {x, y}} = state), do: %{state | waypoint_pos: {y, -x}}

  defp update_state({:forward, fields}, %{waypoint_pos: {w_x, w_y}, ship_pos: {s_x, s_y}} = state),
    do: %{state | ship_pos: {s_x + fields * w_x, s_y + fields * w_y}}
end
