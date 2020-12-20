defmodule Advent20.MonsterMessages do
  @moduledoc """
  Day 19: Monster Messages

  Daily logbook: This was very tough. I thought about how to implement it during saturday and ended up
  dynamically creating validator functions, which would consume the input string so that if nothing was
  left, and the rules were empty, the message would be valid. This seemed like a good idea to begin with,
  but ended up being very verbose and repetitive. But it worked for part 1.

  Then came part 2. And it didn't work. At all. I tried hacking together different approaches, counting
  loop iterations, etc. Gave up in the end, frustrated. Then came day 2 and a little hint from Lasse:

  "Hint 2: Tænk over denne:"

  ```
  0: 1 2
  1: a | a 1
  2: a

  aaa
  ```

  Thinking about it, I see that it means that a message can both be valid and invalid according to the
  validation rules, because some of them might fail and perhaps one will be successful. In this case,
  we would first validate "aaa" against "0: a a" which would be invalid, then:
  "0: (a 1) a" -> "0: (a (a)) a" -> "0: a a a" which would validate.

  This meant that my approach with the validator functions was hard to get working. First of all because
  it was clunky to refactor. Secondly because it didn't handle branching. I read and studied @lasseeberts
  solutions for handling the branches with Enum.flat_map and implemented my solution that way too.
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
        [index, char] when char in ["a", "b"] -> {index, [[{:char, char}]]}
        [index, r] -> {index, [[{:r, r}]]}
        [index, r1, r2] -> {index, [[{:r, r1}, {:r, r2}]]}
        [index, r1, "|", r2] -> {index, [[{:r, r1}], [{:r, r2}]]}
        [index, r1, r2, r3] -> {index, [[{:r, r1}, {:r, r2}, {:r, r3}]]}
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

  # For a message to be valid, it must:
  # (1) Completely match the rule 0, which means that all the sub-rules for rule 0 are satistied
  # (2) Be completely consumed by the rules, there can be no additional characters
  #
  # Ad 1):
  # This is handled by returning [] in the rules below, which is then removed by flat_map.
  # This is done if we run out of message to parse before the rules are all evaluated.
  #
  # Ad 2):
  # After Day 19 part 2, a single message can have multiple validation results due to the loops.
  # This means that a message can finish validation in multiple ways where all rules have been consumed.
  # However, the message is still only valid if the message has been completely consumed, which means
  # that the message is the empty string, "".
  defp valid?(message, rules) do
    "" in match_outer_rule_list("0", message, rules)
  end

  # Map over the outer rule levels (e.g. if there is an OR, it handles both cases)
  # Will be called with a list of rule lists, e.g. [[{r: "42"}], [{r: "42"}, {r: "8"}]]
  # This must be used everytime we dive into a sub-rule, because it might have multiple matches
  defp match_outer_rule_list(rule_no, message, rules) do
    rules
    |> Map.fetch!(rule_no)
    |> Enum.flat_map(&evaluate_rule_list(&1, message, rules))
  end

  # A rule list is empty, return the resulting message
  defp evaluate_rule_list([], message, _rules), do: [message]

  # We have hit a rule
  # First get all possible matches for that rule.
  # Then branch out by evaluating the *remaning* rules on top of each of the possibilities for remaning message.
  defp evaluate_rule_list([{:r, rule} | rule_tail], message, rules) do
    rule
    |> match_outer_rule_list(message, rules)
    |> Enum.flat_map(&evaluate_rule_list(rule_tail, &1, rules))
  end

  # The rule has matched a char with no further rules, return remaning string after char is stripped.
  defp evaluate_rule_list([{:char, char} | []], message, _rules) do
    if String.starts_with?(message, char) do
      # We have a match, return remaining string, which might also be "".
      {_, remaining} = String.split_at(message, 1)
      [remaining]
    else
      # We have no match, return empty list (which will be filtered away by Enum.flat_map)
      []
    end
  end
end
