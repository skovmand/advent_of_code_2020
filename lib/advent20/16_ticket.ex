defmodule Advent20.Ticket do
  @moduledoc """
  Day 16: Ticket Translation
  """

  defp parse(input) do
    [rules_raw, your_ticket_raw, nearby_tickets_raw] =
      input
      |> String.split("\n\n", trim: true)

    rules =
      rules_raw
      |> String.split("\n")
      |> Enum.map(&Regex.run(~r/^(.*): (\d+)-(\d+) or (\d+)-(\d+)/, &1, capture: :all_but_first))
      |> Enum.map(fn [field, r1l, r1h, r2l, r2h] ->
        range1 = String.to_integer(r1l)..String.to_integer(r1h)
        range2 = String.to_integer(r2l)..String.to_integer(r2h)
        {field, MapSet.union(MapSet.new(range1), MapSet.new(range2))}
      end)

    ticket =
      your_ticket_raw
      |> String.split("\n")
      |> Enum.at(1)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    nearby_tickets =
      nearby_tickets_raw
      |> String.split("\n", trim: true)
      |> Enum.drop(1)
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)

    %{rules: rules, ticket: ticket, nearby_tickets: nearby_tickets}
  end

  @doc """
  Part 1: Consider the validity of the nearby tickets you scanned.
  What is your ticket scanning error rate?
  """
  def part_1(input) do
    data = parse(input)

    valid_values =
      Enum.reduce(data.rules, MapSet.new(), fn {_name, range}, acc ->
        MapSet.union(range, acc)
      end)

    data.nearby_tickets
    |> List.flatten()
    |> Enum.reject(&MapSet.member?(valid_values, &1))
    |> Enum.sum()
  end
end
