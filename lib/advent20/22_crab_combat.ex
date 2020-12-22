defmodule Advent20.CrabCombat do
  @moduledoc """
  Day 22: Crab Combat
  """

  defp parse(input) do
    input
    |> String.split(~r/Player .:/, trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(&Enum.map(&1, fn card_no -> String.to_integer(card_no) end))
  end

  @doc """
  Part 1: Play the small crab in a game of Combat using the two decks you just dealt.
          What is the winning player's score?
  """
  def part_1(input) do
    [deck_1, deck_2] = parse(input)

    play_cards(deck_1, deck_2)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn {card, i} -> {card, i + 1} end)
    |> Enum.reduce(0, fn {card, i}, acc ->
      acc + card * i
    end)
  end

  defp play_cards([], winner), do: winner
  defp play_cards(winner, []), do: winner

  defp play_cards(deck_1, deck_2) do
    [top_card_1 | rest_1] = deck_1
    [top_card_2 | rest_2] = deck_2

    if top_card_1 > top_card_2 do
      play_cards(rest_1 ++ [top_card_1] ++ [top_card_2], rest_2)
    else
      play_cards(rest_1, rest_2 ++ [top_card_2] ++ [top_card_1])
    end
  end
end
