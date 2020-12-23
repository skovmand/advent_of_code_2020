defmodule Advent20.CrabCups do
  @moduledoc """
  Day 23: Crab Cups
  """

  defp parse(input) do
    String.trim(input)
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
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

  @doc """
  Part 2: Determine which two cups will end up immediately clockwise of cup 1.
  What do you get if you multiply their labels together?
  """
  def part_2(input) do
    input
    |> parse()
    |> fill()
    |> first_state()
    |> Stream.iterate(&step/1)
    |> Enum.find(&(&1.move == 10_000_001))
    |> two_cups()
  end

  defp first_state(input_cups) do
    last_cup = List.last(input_cups)

    %{
      ring: ring(input_cups),
      move: 1,
      picked_cup: last_cup,
      max_label: Enum.max(input_cups)
    }
  end

  # Fill the list with numbers to 1_000_000
  defp fill(input_cups) do
    from = Enum.max(input_cups) + 1
    extra_numbers = from..1_000_000 |> Enum.to_list()

    input_cups ++ extra_numbers
  end

  defp ring([first_cup | _] = input_cups) do
    input_cups
    |> Kernel.++([first_cup])
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.into(%{}, fn [current, next] -> {current, next} end)
  end

  defp step(%{ring: ring, move: move, picked_cup: prev_picked_cup, max_label: max_label}) do
    current_cup = Map.fetch!(ring, prev_picked_cup)
    pickup = pickup_cups(ring, current_cup)
    destination_cup = destination_cup(current_cup, pickup, max_label)
    updated_ring = place_pickup(ring, current_cup, pickup, destination_cup)

    %{
      max_label: max_label,
      move: move + 1,
      ring: updated_ring,
      picked_cup: current_cup
    }
  end

  # Pick up the 3 cups after the current cup from the ring
  defp pickup_cups(ring, current_cup) do
    n_plus_1 = Map.fetch!(ring, current_cup)
    n_plus_2 = Map.fetch!(ring, n_plus_1)
    n_plus_3 = Map.fetch!(ring, n_plus_2)

    [n_plus_1, n_plus_2, n_plus_3]
  end

  # try cups from cup_label and decreasing by one, wrap when cup_label < 1
  defp destination_cup(current_cup, pickup, max) do
    current_cup
    |> Stream.iterate(fn cup_label ->
      cup_label
      |> Kernel.-(1)
      |> case do
        number when number < 1 -> max
        number -> number
      end
    end)
    |> Stream.reject(&(&1 == current_cup))
    |> Stream.reject(&(&1 in pickup))
    |> Enum.take(1)
    |> hd()
  end

  # place the pickup in the ring by updating 3 keys
  # first, update destination_cup to point at first pickup card
  # then update last pickup card to point to the card the destination_cup pointed to before
  # lastly point the current cup to the card that pickup_3 pointed to before
  defp place_pickup(ring, current_cup, [pickup_1, _, pickup_3], destination_cup) do
    next_cup = Map.fetch!(ring, pickup_3)
    previous_dest_cup_next = Map.fetch!(ring, destination_cup)

    ring
    |> Map.put(destination_cup, pickup_1)
    |> Map.put(pickup_3, previous_dest_cup_next)
    |> Map.put(current_cup, next_cup)
  end

  # Get the final labels
  defp labels(%{ring: ring}) do
    c1 = Map.fetch!(ring, 1)
    c2 = Map.fetch!(ring, c1)
    c3 = Map.fetch!(ring, c2)
    c4 = Map.fetch!(ring, c3)
    c5 = Map.fetch!(ring, c4)
    c6 = Map.fetch!(ring, c5)
    c7 = Map.fetch!(ring, c6)
    c8 = Map.fetch!(ring, c7)

    [c1, c2, c3, c4, c5, c6, c7, c8]
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join()
  end

  # Get the final labels
  defp two_cups(%{ring: ring}) do
    cup_1 = Map.fetch!(ring, 1)
    cup_2 = Map.fetch!(ring, cup_1)

    cup_1 * cup_2
  end
end
