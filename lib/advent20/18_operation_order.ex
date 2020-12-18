defmodule Advent20.OperationOrder do
  @moduledoc """
  Day 18: Operation Order

  Phew this day was hard. I am not used to parsing. I read up on algorithms for parsing math expressions
  and read about the difference between infix and postfix notation. Infix is e.g. 2+4*(3+4) and the same
  in postfix would be written as 2434+*+ which at first seems really weird.

  However! The postfix notation is really easy to evaluate on a computer. It can be done using only a single
  stack and a recursive function (as done in this module at the bottom in `evaluate_postfix/1`).

  So. This D18 consists of a infix to postfix converter which takes custom operator precedences for only the
  + and * operators. It converts all input equations to postfix using these precedences and then evaluates
  the postfix equations.

  The D18 puzzles is actually our normal math, but with custom operator precedences.
  In part 1 the precedences are the same for + and * (I have set both to 1)
  In part 2 the + operator takes precedence over *, so the precedence is 2 for + and 1 for -
  """

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn string -> "(#{string})" end)
  end

  def part_1(input) do
    calculate(input, %{*: 1, +: 1})
  end

  def part_2(input) do
    calculate(input, %{*: 1, +: 2})
  end

  def calculate(input, operator_precedences) do
    input
    |> parse()
    |> Enum.map(&tokenize/1)
    |> Enum.map(&to_postfix(&1, operator_precedences))
    |> Enum.map(&evaluate_postfix/1)
    |> Enum.sum()
  end

  def tokenize(string) do
    string
    |> String.codepoints()
    |> Enum.reject(&(&1 == " "))
    |> Enum.map(fn
      "+" -> :+
      "*" -> :*
      "(" -> :start_parens
      ")" -> :end_parens
      char -> String.to_integer(char)
    end)
  end

  def to_postfix(tokens, precedence) do
    do_parse_rpe(tokens, [], [], precedence)
  end

  # Handle a number by pushing it into postfix
  defp do_parse_rpe([number | equation], postfix, opstack, precedence) when is_integer(number) do
    do_parse_rpe(equation, [number | postfix], opstack, precedence)
  end

  # Encountering a start parenthesis, just push it to the opstack
  defp do_parse_rpe([:start_parens | equation], postfix, opstack, precedence) do
    do_parse_rpe(equation, postfix, [:start_parens | opstack], precedence)
  end

  # End parenthesis, pop from the opstack onto the postfix until the start parens is encountered
  # Neither start or end parens are added to the postfix
  defp do_parse_rpe([:end_parens | equation], postfix, opstack, precedence) do
    {remaning_parens_ops, [:start_parens | new_opstack]} = Enum.split_while(opstack, fn x -> x != :start_parens end)
    do_parse_rpe(equation, Enum.reverse(remaning_parens_ops) ++ postfix, new_opstack, precedence)
  end

  # Handle operations with + or * -->
  # If the first element in the opstack is a parens, just push the operator to the opstack
  defp do_parse_rpe([operator | equation], postfix, [:start_parens | _] = opstack, precedence)
       when operator in [:*, :+] do
    do_parse_rpe(equation, postfix, [operator | opstack], precedence)
  end

  # If the operator is * or + and we have don't have a parens first in the opstack
  defp do_parse_rpe([operator | equation], postfix, opstack, precedence) when operator in [:*, :+] do
    operator_precedence = Map.fetch!(precedence, operator)
    first_opstack_element_precedence = Map.fetch!(precedence, List.first(opstack))

    # If the operator precedence is greater than or equal to the next operator in the opstack, just push it to the opstack
    # Otherwise, pop the opstack operator into the postfix and put the operator into the opstack
    if operator_precedence > first_opstack_element_precedence do
      do_parse_rpe(equation, postfix, [operator | opstack], precedence)
    else
      [opstack_operator | opstack_rest] = opstack
      do_parse_rpe(equation, [opstack_operator | postfix], [operator | opstack_rest], precedence)
    end
  end

  # We are finished!
  defp do_parse_rpe([], postfix, [], _), do: postfix |> Enum.reverse()

  defp evaluate_postfix(postfix) do
    do_evaluate_postfix(postfix, [])
  end

  defp do_evaluate_postfix([number | tail], number_stack) when is_integer(number) do
    do_evaluate_postfix(tail, [number | number_stack])
  end

  defp do_evaluate_postfix([:* | tail], [number1, number2 | number_stack_tail]) do
    do_evaluate_postfix(tail, [number1 * number2 | number_stack_tail])
  end

  defp do_evaluate_postfix([:+ | tail], [number1, number2 | number_stack_tail]) do
    do_evaluate_postfix(tail, [number1 + number2 | number_stack_tail])
  end

  defp do_evaluate_postfix([], [number]), do: number
end
