defmodule Advent20.PoliciesAndPasswords do
  @moduledoc """
  Day 2: Password Philosophy
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
end
