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
      |> Enum.map(fn [number | tail] -> {number, tail} end)
      |> Enum.into(%{}, fn {number, signature} -> {number, rule_match_function(signature)} end)

    messages =
      messages_raw
      |> String.split("\n", trim: true)

    {rules, messages}
  end

  # Generate a function that matches the a or b literals, e.g. ('22: "a"')
  defp rule_match_function([char]) when char in ["a", "b"] do
    fn
      [input_char | tail], _rules -> if(input_char == char, do: {:ok, tail}, else: :error)
      [], _rules -> :underflow
    end
  end

  # Matcher function for a single "redirecting" rule, (e.g. '42: 19')
  defp rule_match_function([rule]) do
    fn list, rules ->
      matcher = Map.fetch!(rules, rule)
      matcher.(list, rules)
    end
  end

  # Generate a matcher for 2-rule matchers (e.g. '0: 1 4')
  defp rule_match_function([rule1, rule2]) do
    fn list, rules ->
      matcher1 = Map.fetch!(rules, rule1)
      matcher2 = Map.fetch!(rules, rule2)

      with {:ok, rest} <- matcher1.(list, rules),
           {:ok, rest} <- matcher2.(rest, rules) do
        {:ok, rest}
      end
    end
  end

  # Generate a matcher for or-style rule matchers (e.g. '0: 1 4 | 4 5')
  defp rule_match_function([rule1, "|", rule2]) do
    fn list, rules ->
      matcher1 = Map.fetch!(rules, rule1)
      matcher2 = Map.fetch!(rules, rule2)

      case matcher1.(list, rules) do
        {:ok, rest} -> {:ok, rest}
        :error -> matcher2.(list, rules)
        :underflow -> :underflow
      end
    end
  end

  # Generate a matcher for 3-rule matchers (e.g. "0: 1 4 5")
  defp rule_match_function([rule1, rule2, rule3]) do
    fn list, rules ->
      matcher1 = Map.fetch!(rules, rule1)
      matcher2 = Map.fetch!(rules, rule2)
      matcher3 = Map.fetch!(rules, rule3)

      with {:ok, rest} <- matcher1.(list, rules),
           {:ok, rest} <- matcher2.(rest, rules),
           {:ok, rest} <- matcher3.(rest, rules) do
        {:ok, rest}
      end
    end
  end

  # Generate a matcher for or-style rule matchers (e.g. "0: 1 | 4 5")
  defp rule_match_function([rule1, "|", rule2, rule3]) do
    fn list, rules ->
      matcher1 = Map.fetch!(rules, rule1)
      matcher2 = Map.fetch!(rules, rule2)
      matcher3 = Map.fetch!(rules, rule3)

      case matcher1.(list, rules) do
        {:ok, rest} ->
          {:ok, rest}

        :error ->
          with {:ok, rest} <- matcher2.(list, rules),
               {:ok, rest} <- matcher3.(rest, rules) do
            {:ok, rest}
          end

        :underflow ->
          :underflow
      end
    end
  end

  # Generate a matcher for or-style rule matchers (e.g. "0: 1 4 | 4 5")
  defp rule_match_function([rule1, rule2, "|", rule3, rule4]) do
    fn list, rules ->
      matcher1 = Map.fetch!(rules, rule1)
      matcher2 = Map.fetch!(rules, rule2)
      matcher3 = Map.fetch!(rules, rule3)
      matcher4 = Map.fetch!(rules, rule4)

      with {:ok, rest} <- matcher1.(list, rules),
           {:ok, rest} <- matcher2.(rest, rules) do
        {:ok, rest}
      else
        :error ->
          with {:ok, rest} <- matcher3.(list, rules),
               {:ok, rest} <- matcher4.(rest, rules) do
            {:ok, rest}
          end

        :underflow ->
          :underflow
      end
    end
  end

  # Generate a matcher for or-style rule matchers (e.g. "0: 1 4 | 4 5 7")
  defp rule_match_function([rule1, rule2, "|", rule3, rule4, rule5]) do
    fn list, rules ->
      matcher1 = Map.fetch!(rules, rule1)
      matcher2 = Map.fetch!(rules, rule2)
      matcher3 = Map.fetch!(rules, rule3)
      matcher4 = Map.fetch!(rules, rule4)
      matcher5 = Map.fetch!(rules, rule5)

      with {:ok, rest} <- matcher1.(list, rules),
           {:ok, rest} <- matcher2.(rest, rules) do
        {:ok, rest}
      else
        :error ->
          with {:ok, rest} <- matcher3.(list, rules),
               {:ok, rest} <- matcher4.(rest, rules),
               {:ok, rest} <- matcher5.(rest, rules) do
            {:ok, rest}
          end

        :underflow ->
          :underflow
      end
    end
  end

  def part_1(input) do
    {rules, messages} = parse(input)
    Enum.count(messages, &valid?(&1, rules))
  end

  defp valid?(message, %{"0" => validator} = rules) do
    message
    |> String.codepoints()
    |> validator.(rules)
    |> case do
      # We have matched an entire string
      {:ok, []} ->
        true

      # The validation rules terminated without parsing the entire string
      {:ok, _remaining} ->
        false

      # The validation failed
      :error ->
        false

      # We ran out of string
      :underflow ->
        true
    end
  end
end
