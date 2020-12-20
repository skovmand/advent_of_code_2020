defmodule Advent20.MonsterMessages do
  @moduledoc """
  Day 19: Monster Messages
  """

  defp parse(input) do
    [rules_raw, messages_raw] = String.split(input, "\n\n", trim: true)

    regexes = [
      ~r/^(\d+): (\d+)$/,
      ~r/^(\d+): (\d+) (\|) (\d+)$/,
      ~r/^(\d+): (\d+) (\|) (\d+) (\d+)$/,
      ~r/^(\d+): (\d+) (\d+) (\|) (\d+) (\d+)$/,
      ~r/^(\d+): (\d+) (\d+) (\|) (\d+) (\d+) (\d+)$/,
      ~r/^(\d+): (\d+) (\d+) (\d+)$/,
      ~r/^(\d+): (\d+) (\d+)$/,
      ~r/^(\d+): "([a-z])"$/
    ]

    rules =
      rules_raw
      |> String.split("\n", trim: true)
      |> Enum.map(fn string ->
        Enum.find_value(regexes, &Regex.run(&1, string, capture: :all_but_first))
      end)
      |> Enum.map(fn
        [index, char] when char in ["a", "b"] -> {index, [{:char, char}]}
        [index, r] -> {index, [{:r, r}]}
        [index, r1, r2] -> {index, [{:r, r1}, {:r, r2}]}
        [index, r1, "|", r2] -> {index, [[{:r, r1}], [{:r, r2}]]}
        [index, r1, r2, r3] -> {index, [{:r, r1}, {:r, r2}, {:r, r3}]}
        [index, r1, "|", r2, r3] -> {index, [[{:r, r1}], [{:r, r2}, {:r, r3}]]}
        [index, r1, r2, "|", r3, r4] -> {index, [[{:r, r1}, {:r, r2}], [{:r, r3}, {:r, r4}]]}
        [index, r1, r2, "|", r3, r4, r5] -> {index, [[{:r, r1}, {:r, r2}], [{:r, r3}, {:r, r4}, {:r, r5}]]}
      end)
      |> Enum.into(%{})

    messages = messages_raw |> String.split("\n", trim: true)

    {rules, messages}
  end

  def part_1(input) do
    {rules, messages} = parse(input)

    Enum.count(messages, &valid?(&1, rules))
  end

  def part_2(input) do
    {rules, messages} =
      input
      |> String.replace("8: 42", "8: 42 | 42 8")
      |> String.replace("11: 42 31", "11: 42 31 | 42 11 31")
      |> parse()

    Enum.count(messages, &valid?(&1, rules))
  end

  defp valid?(message, rules) do
    _root_validator = Map.fetch!(rules, "0")

    true
  end
end
