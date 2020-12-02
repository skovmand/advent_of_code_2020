defmodule Advent20.ExpenseReportTest do
  use ExUnit.Case

  alias Advent20.ExpenseReport

  @expenses "01_expense_report.txt"
            |> Path.expand("input_files")
            |> File.read!()
            |> String.split("\n", trim: true)
            |> Enum.map(&String.to_integer/1)

  test "A: It finds the 2 numbers that sum up to 2020" do
    {number_1, number_2} = ExpenseReport.find_sum_2(@expenses, 2020)

    assert number_1 + number_2 == 2020
    assert number_1 * number_2 == 870331
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
