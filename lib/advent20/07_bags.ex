defmodule Advent20.Bags do
  @moduledoc """
  Day 7: Handy Haversacks
  """

  # Parse the bag input
  defp parse_bags(bag_input) do
    bag_input
    |> String.split(".\n", trim: true)
    |> Enum.map(&String.replace(&1, ~r/ bags?/, ""))
    |> Enum.map(&String.split(&1, " contain "))
    |> Enum.into(%{}, fn [title, bags_contained] -> {title, parse_bags_contained(bags_contained)} end)
  end

  # when a bag contains no other bags, it states "no other bags"
  defp parse_bags_contained("no other"), do: []

  # parse e.g. "2 golden bags" into [2, "golden bags"]
  defp parse_bags_contained(bags) do
    bags
    |> String.split(", ", trim: true)
    |> Enum.map(&Regex.run(~r/(\d+) (.+)$/, &1, capture: :all_but_first))
    |> Enum.map(fn [count, title] -> [String.to_integer(count), title] end)
  end

  @doc """
  1: How many bag colors can eventually contain at least one shiny gold bag?
  """
  def bags_eventually_containing_one_shiny_gold_bag(bag_input) do
    # We just remove the count from the contained bags for simplicity
    all_bags_without_count = parse_bags(bag_input) |> remove_count_from_subbags()

    all_bags_without_count
    |> Enum.filter(&contains_shiny_gold_bag?(&1, all_bags_without_count))
    |> Enum.count()
  end

  defp remove_count_from_subbags(bags) do
    Enum.into(bags, %{}, fn {title, subbags} ->
      {title, Enum.map(subbags, fn [_count, title] -> title end)}
    end)
  end

  defp contains_shiny_gold_bag?({_title, bags_contained}, all_bags) do
    if "shiny gold" in bags_contained do
      true
    else
      all_bags
      |> Map.take(bags_contained)
      |> Enum.find(false, &contains_shiny_gold_bag?(&1, all_bags))
    end
  end
end
