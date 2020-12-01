defmodule Advent20.ExpenseReportTest do
  use ExUnit.Case

  @expenses "01_expense_report.txt"
            |> Path.expand("input_files")
            |> File.read!()
            |> String.split("\n", trim: true)
            |> Enum.map(&String.to_integer/1)

  test "A: It finds the 2 numbers that sum up to 2020" do
    results =
      for expense_1 <- @expenses,
          expense_2 <- @expenses,
          expense_1 + expense_2 == 2020,
          do: {expense_1, expense_2}

    # We get the result as both {a,b} and {b,a} from the above.
    # Just proving that with a pattern match:
    [{exp_1, exp_2}, {exp_2, exp_1}] = results

    assert exp_1 + exp_2 == 2020
    assert exp_1 * exp_2 == 870331
  end

  test "B: It finds the 3 numbers that sum up to 2020" do
    results =
      for expense_1 <- @expenses,
          expense_2 <- @expenses,
          expense_3 <- @expenses,
          expense_1 + expense_2 + expense_3 == 2020,
          do: {expense_1, expense_2, expense_3}

    [{exp_1, exp_2, exp_3} | _tail] = results

    assert exp_1 + exp_2 + exp_3 == 2020
    assert exp_1 * exp_2 * exp_3 == 283025088
  end
end
