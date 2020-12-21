defmodule Advent20.Allergen do
  @moduledoc """
  Day 21: Allergen Assessment
  """

  defp parse(input) do
    foods =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&Regex.run(~r/(.+) \(contains (.+)\)/, &1, capture: :all_but_first))
      |> Enum.with_index()
      |> Enum.into(%{}, fn {[ingredients, allergens], i} ->
        ingredients = String.split(ingredients, " ")
        allergens = String.split(allergens, ", ")

        {i, %{ingredients: ingredients, allergens: allergens}}
      end)

    %{
      foods: foods,
      all_allergens: foods |> Map.values() |> Enum.flat_map(& &1.allergens) |> MapSet.new(),
      all_ingredients: foods |> Map.values() |> Enum.flat_map(& &1.ingredients) |> MapSet.new()
    }
  end

  @doc """
  Part 1: Determine which ingredients cannot possibly contain any of the
  allergens in your list. How many times do any of those ingredients appear?
  """
  def part_1(input) do
    data = parse(input)
    allergen_to_food_map = allergen_to_food_map(data.all_allergens, data.foods)

    allergen_ingredients =
      identify_allergens(data.all_allergens, %{}, allergen_to_food_map, data.foods) |> Map.values() |> MapSet.new()

    non_allergen_ingredients = MapSet.difference(data.all_ingredients, allergen_ingredients)

    data.foods
    |> Map.values()
    |> Enum.flat_map(& &1.ingredients)
    |> Enum.filter(&(&1 in non_allergen_ingredients))
    |> Enum.count()
  end

  @doc """
  Part 2: Time to stock your raft with supplies. What is your canonical dangerous ingredient list?
  """
  def part_2(input) do
    data = parse(input)
    allergen_to_food_map = allergen_to_food_map(data.all_allergens, data.foods)

    identify_allergens(data.all_allergens, %{}, allergen_to_food_map, data.foods)
    |> Enum.sort_by(fn {allergen, _ingredient} -> allergen end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.join(",")
  end

  # Create a map of allergen => recipes containing the allergen
  defp allergen_to_food_map(all_allergens, foods) do
    Enum.reduce(all_allergens, %{}, fn allergen, acc ->
      recipes =
        foods
        |> Enum.filter(fn {_i, %{allergens: allergens}} -> allergen in allergens end)
        |> Enum.map(&elem(&1, 0))

      Map.put(acc, allergen, recipes)
    end)
  end

  # Recursive function running until all allergens are identified
  # Returns a map of allergen => ingredient
  defp identify_allergens(all_allergens, identified, allergen_to_food_map, foods) do
    if Enum.count(all_allergens) == Enum.count(identified) do
      identified
    else
      identified_allergens = MapSet.new(Map.keys(identified))
      identified_ingredients = MapSet.new(Map.values(identified))
      not_identified = MapSet.difference(all_allergens, identified_allergens)

      # Do one more identification round!
      identified =
        Enum.reduce(not_identified, identified, fn allergen, identified ->
          recipes = Map.fetch!(allergen_to_food_map, allergen)

          recipes
          |> Enum.map(&Map.fetch!(foods, &1))
          |> Enum.map(&Map.fetch!(&1, :ingredients))
          |> Enum.map(&MapSet.new/1)
          |> Enum.reduce(&MapSet.intersection/2)
          |> MapSet.difference(identified_ingredients)
          |> MapSet.to_list()
          |> case do
            [ingredient] -> Map.put(identified, allergen, ingredient)
            _ -> identified
          end
        end)

      identify_allergens(all_allergens, identified, allergen_to_food_map, foods)
    end
  end
end
