defmodule Advent20.Passport do
  @moduledoc """
  Day 4: Passport Processing
  """

  def count_valid_passports(passport_input_lists) do
    passport_input_lists
    |> Stream.map(&create_passport/1)
    |> Enum.count(&valid_passport?/1)
  end

  defp create_passport(password_input_list) do
    password_input_list
    |> Enum.reduce(%{}, fn input, passport ->
      [field, value] = String.split(input, ":")
      Map.put(passport, field, value)
    end)
  end

  defp valid_passport?(%{} = passport) do
    ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"] |> Enum.all?(&Map.has_key?(passport, &1))
  end
end
