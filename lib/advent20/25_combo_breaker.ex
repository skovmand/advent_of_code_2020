defmodule Advent20.ComboBreaker do
  @moduledoc """
  --- Day 25: Combo Breaker ---
  """

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part_1(input) do
    pubkeys = parse(input)

    # Find the loop size of the first matching public key using subject_number 7
    {pubkey_1, loop_size_1} =
      Stream.iterate(1, &rem(&1 * 7, 20_201_227))
      |> Stream.with_index()
      |> Enum.find(fn {pubkey, _loop_size} -> pubkey in pubkeys end)

    # Get the other public key
    [other_pubkey] = Enum.reject(pubkeys, &(&1 == pubkey_1))

    # Then, run the transform against the other pubkey, using our the known loop size
    Stream.iterate(1, &rem(&1 * other_pubkey, 20_201_227))
    |> Enum.at(loop_size_1)
  end
end
