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
    valid_values = valid_values(data.rules)

    data.nearby_tickets
    |> List.flatten()
    |> Enum.reject(&MapSet.member?(valid_values, &1))
    |> Enum.sum()
  end

  defp valid_values(rules) do
    Enum.reduce(rules, MapSet.new(), fn {_name, range}, acc ->
      MapSet.union(range, acc)
    end)
  end

  @doc """
  Part 2: Once you work out which field is which, look for the six fields
  on your ticket that start with the word departure. 

  What do you get if you multiply those six values together?
  """
  def part_2(input) do
    data = parse(input)
    valid_values = valid_values(data.rules)

    data.nearby_tickets
    |> Enum.filter(fn ticket_numbers ->
      Enum.all?(ticket_numbers, fn number -> number in valid_values end)
    end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {column, i}, acc ->
      Enum.filter(data.rules, fn {_label, range} ->
        Enum.all?(column, fn x -> x in range end)
      end)
      |> Enum.map(fn {label, _} -> label end)
      |> Enum.reduce(acc, fn rule_label, acc ->
        Map.update(acc, rule_label, [i], fn values -> [i | values] end)
      end)
    end)
    |> Enum.sort_by(fn {_, valid_indexes} -> length(valid_indexes) end)
    |> Enum.reduce(%{}, fn {field_name, valid_indexes}, acc ->
      used_indexes = Map.values(acc)
      [final_index] = Enum.reject(valid_indexes, fn index -> index in used_indexes end)
      Map.put(acc, field_name, final_index)
    end)
    |> Enum.filter(fn {field_name, _i} -> String.starts_with?(field_name, "departure") end)
    |> Enum.map(fn {_, index} -> Enum.at(data.ticket, index) end)
    |> Enum.reduce(&Kernel.*/2)
  end
end
