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
    |> final_score()
  end

  def part_2(input) do
    [deck_1, deck_2] = parse(input)

    play_recursive_combat(deck_1, deck_2, MapSet.new())
    |> elem(1)
    |> final_score()
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

  defp play_recursive_combat(winning_deck, [], _), do: {:player1, winning_deck}
  defp play_recursive_combat([], winning_deck, _), do: {:player2, winning_deck}

  defp play_recursive_combat(deck_1, deck_2, seen) do
    if {deck_1, deck_2} in seen do
      {:player1, deck_1}
    else
      # Loop check: If we have seen deck_1 and deck_2 in this game before, player 1 wins the game
      [top_card_1 | rest_1] = deck_1
      [top_card_2 | rest_2] = deck_2

      seen = MapSet.put(seen, {deck_1, deck_2})

      # Check: Do both players have at least the number of cards remaining in their decks as the value of top card?
      round_winner =
        if top_card_1 <= length(rest_1) and top_card_2 <= length(rest_2) do
          sub_deck_1 = Enum.take(rest_1, top_card_1)
          sub_deck_2 = Enum.take(rest_2, top_card_2)

          case play_recursive_combat(sub_deck_1, sub_deck_2, MapSet.new()) do
            {:player1, _} -> :player1
            {:player2, _} -> :player2
          end
        else
          if top_card_1 > top_card_2, do: :player1, else: :player2
        end

      if round_winner == :player1 do
        play_recursive_combat(rest_1 ++ [top_card_1] ++ [top_card_2], rest_2, seen)
      else
        play_recursive_combat(rest_1, rest_2 ++ [top_card_2] ++ [top_card_1], seen)
      end
    end
  end

  defp final_score(winning_deck) do
    winning_deck
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn {card, i} -> {card, i + 1} end)
    |> Enum.reduce(0, fn {card, i}, acc ->
      acc + card * i
    end)
  end
end
