defmodule Advent20.ComboBreaker do
  @moduledoc """
  --- Day 25: Combo Breaker ---
  """

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part_1_test(input) do
    pubkeys = parse(input)

    {loop_size_1, pubkey_1} =
      1..100
      |> Stream.map(fn loop_size -> {loop_size, transform_subject_number(7, loop_size)} end)
      |> Enum.find(fn {_loop_size, pubkey} -> pubkey in pubkeys end)

    [other_pubkey] = Enum.reject(pubkeys, &(&1 == pubkey_1))

    transform_subject_number(other_pubkey, loop_size_1)
  end

  # Blarh, it turns out Elixir has no :math.pow/3 as Pythons pow/3:
  #
  # From python 3.9 docs: pow(base, exp, [mod]): Return base to the power exp;
  # if mod is present, return base to the power exp, modulo mod (computed more
  # efficiently than pow(base, exp) % mod)
  def part_1(input) do
    pubkeys = parse(input)

    {loop_size_1, pubkey_1} =
      [5_163_354]
      |> Stream.map(fn loop_size -> {loop_size, transform_subject_number(7, loop_size)} end)
      |> Enum.find(fn {_loop_size, pubkey} -> pubkey in pubkeys end)

    [other_pubkey] = Enum.reject(pubkeys, &(&1 == pubkey_1))

    transform_subject_number(other_pubkey, loop_size_1)
  end

  def transform_subject_number(subject_number, loop_size) do
    Stream.iterate(1, &rem(&1 * subject_number, 20_201_227))
    |> Enum.at(loop_size)
  end
end
