defmodule Advent20.ExpenseReportTest do
  use ExUnit.Case

  alias Advent20.ExpenseReport

  @expenses "01_expense_report.txt"
            |> Path.expand("input_files")
            |> File.read!()
            |> String.split("\n", trim: true)
            |> Enum.map(&String.to_integer/1)
            |> MapSet.new()

  test "A: It finds the 2 numbers that sum up to 2020" do
    {number_1, number_2} = ExpenseReport.find_sum_2(@expenses, 2020)

    assert number_1 + number_2 == 2020
    assert number_1 * number_2 == 870_331
  end

  test "B: It finds the 3 numbers that sum up to 2020" do
    {number_1, number_2, number_3} = ExpenseReport.find_sum_3(@expenses, 2020)

    assert number_1 + number_2 + number_3 == 2020
    assert number_1 * number_2 * number_3 == 283_025_088
  end
end
