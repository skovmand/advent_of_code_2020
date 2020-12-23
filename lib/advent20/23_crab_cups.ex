defmodule Advent20.CrabCups do
  @moduledoc """
  Day 23: Crab Cups
  """

  defp parse(input) do
    String.trim(input)
    |> String.codepoints()
  end

  @doc """
  Part 1: Using your labeling, simulate 100 moves.
  What are the labels on the cups after cup 1?
  """
  def part_1(input) do
    input
    |> parse()
    |> first_state()
    |> Stream.iterate(&step/1)
    |> Enum.find(&(&1.move == 101))
    |> labels()
  end

  defp first_state(circle) do
    %{
      circle: circle,
      move: 1,
      picked_cup: List.last(circle)
    }
  end

  defp step(%{circle: circle, move: move, picked_cup: prev_picked_cup}) do
    current_cup = current_cup(circle, prev_picked_cup)
    pickup = pickup_cups(circle, current_cup)
    destination_cup = destination_cup(circle, current_cup, pickup)

    %{
      move: move + 1,
      circle: place_pickup(circle, pickup, destination_cup),
      picked_cup: current_cup
    }
  end

  # Get the current cup. This is the cup next to the previous cup, clockwise.
  defp current_cup(circle, prev_picked_cup) do
    Stream.cycle(circle)
    |> Stream.drop_while(&(&1 != prev_picked_cup))
    |> Stream.drop(1)
    |> Enum.take(1)
    |> hd()
  end

  # Pick up the 3 cups after the current cup. Using stream for the fun of it.
  defp pickup_cups(circle, current_cup) do
    Stream.cycle(circle)
    |> Stream.drop_while(&(&1 != current_cup))
    |> Stream.drop(1)
    |> Enum.take(3)
  end

  # Remove the pickup from the circle, then sort in descending order, jump to the
  # current cup and take the next value
  defp destination_cup(circle, current_cup, pickup) do
    circle
    |> Enum.reject(&(&1 in pickup))
    |> Enum.sort(&Kernel.>=/2)
    |> Stream.cycle()
    |> Stream.drop_while(&(&1 != current_cup))
    |> Stream.drop(1)
    |> Enum.take(1)
    |> hd()
  end

  # Place the pickup right after the destination cup
  defp place_pickup(circle, pickup, destination_cup) do
    circle_without_pickup = Enum.reject(circle, &(&1 in pickup))

    dest_index =
      Enum.find_index(circle_without_pickup, &(&1 == destination_cup))
      |> Kernel.+(1)

    circle_without_pickup
    |> List.insert_at(dest_index, pickup)
    |> List.flatten()
  end

  # Get the final labels
  defp labels(%{circle: circle}) do
    Stream.cycle(circle)
    |> Stream.drop_while(&(&1 != "1"))
    |> Stream.drop(1)
    |> Enum.take(8)
    |> Enum.join()
  end
end
