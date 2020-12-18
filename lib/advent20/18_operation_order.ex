defmodule Advent20.OperationOrder do
  @moduledoc """
  """

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn string -> "(#{string})" end)
  end

  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&tokenize/1)
    |> Enum.map(&to_postfix/1)
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

  @operator_precedence %{*: 1, +: 1}

  def to_postfix(tokens) do
    do_parse_rpe(tokens, [], [])
  end

  # Handle a number by pushing it into postfix
  defp do_parse_rpe([number | equation], postfix, opstack) when is_integer(number) do
    do_parse_rpe(equation, [number | postfix], opstack)
  end

  # Encountering a start parenthesis, just push it to the opstack
  defp do_parse_rpe([:start_parens | equation], postfix, opstack) do
    do_parse_rpe(equation, postfix, [:start_parens | opstack])
  end

  # End parenthesis, pop from the opstack onto the postfix until the start parens is encountered
  # Neither start or end parens are added to the postfix
  defp do_parse_rpe([:end_parens | equation], postfix, opstack) do
    {remaning_parens_ops, [:start_parens | new_opstack]} = Enum.split_while(opstack, fn x -> x != :start_parens end)
    do_parse_rpe(equation, Enum.reverse(remaning_parens_ops) ++ postfix, new_opstack)
  end

  # Handle operations
  # If the first element in the opstack is a parens, just push the operator to the opstack
  defp do_parse_rpe([operator | equation], postfix, [:start_parens | _] = opstack) when operator in [:*, :+] do
    do_parse_rpe(equation, postfix, [operator | opstack])
  end

  # The same if the opstack is empty, just push the operator
  defp do_parse_rpe([operator | equation], postfix, [] = opstack) when operator in [:*, :+] do
    do_parse_rpe(equation, postfix, [operator | opstack])
  end

  # If the first operator in the opstack has a precedence
  defp do_parse_rpe([operator | equation], postfix, opstack) when operator in [:*, :+] do
    operator_precedence = Map.fetch!(@operator_precedence, operator)
    first_opstack_element_precedence = Map.fetch!(@operator_precedence, List.first(opstack))

    # If the operator precendence is greater than or equal to the next operator in the opstack, just push it to the opstack
    # Otherwise, pop the opstack operator into the postfix and put the operator into the opstack
    if operator_precedence > first_opstack_element_precedence do
      do_parse_rpe(equation, postfix, [operator | opstack])
    else
      [opstack_operator | opstack_rest] = opstack
      do_parse_rpe(equation, [opstack_operator | postfix], [operator | opstack_rest])
    end
  end

  defp do_parse_rpe([], postfix, []), do: postfix |> Enum.reverse()

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
