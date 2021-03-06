defmodule Advent20.PoliciesAndPasswords do
  @moduledoc """
  Day 2: Password Philosophy
  """

  @doc """
  Part 1: How many passwords are valid according to their policies?
  """
  def count_valid_passwords(password_policies) do
    password_policies
    |> Stream.map(&split_policy_and_password/1)
    |> Stream.map(&prepare/1)
    |> Stream.filter(&valid_password?/1)
    |> Enum.count()
  end

  defp split_policy_and_password(policy_and_password) do
    Regex.run(~r/(\d+)-(\d+) (.): (.+)$/, policy_and_password, capture: :all_but_first)
  end

  # Convert strings to integers for low and high values
  defp prepare([low, high, character, password]) do
    [String.to_integer(low), String.to_integer(high), character, password]
  end

  defp valid_password?([low, high, character, password]) do
    count =
      password
      |> String.codepoints()
      |> Enum.count(&(&1 == character))

    count >= low and count <= high
  end

  @doc """
  Part 2: How many passwords are valid according to the new interpretation of the policies?
  """
  def count_valid_passwords_with_2nd_policy(password_policies) do
    password_policies
    |> Stream.map(&split_policy_and_password/1)
    |> Stream.map(&prepare/1)
    |> Stream.filter(&valid_password_with_new_policy?/1)
    |> Enum.count()
  end

  defp valid_password_with_new_policy?([pos_1, pos_2, character, password]) do
    password_chars = String.codepoints(password)
    char_at_pos_1 = Enum.at(password_chars, pos_1 - 1)
    char_at_pos_2 = Enum.at(password_chars, pos_2 - 1)

    xor(character == char_at_pos_1, character == char_at_pos_2)
  end

  defp xor(true, false), do: true
  defp xor(false, true), do: true
  defp xor(_, _), do: false
end
