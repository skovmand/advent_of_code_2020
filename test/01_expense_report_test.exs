defmodule Advent20.ExpenseReportTest do
  use ExUnit.Case, async: true

  alias Advent20.ExpenseReport

  @input Path.expand("01_expense_report.txt", "input_files") |> File.read!()

  test "1: It finds the 2 numbers that sum up to 2020" do
    {:ok, {number_1, number_2}} = ExpenseReport.find_sum_of_2_numbers(@input)

    assert number_1 + number_2 == 2020
    assert number_1 * number_2 == 870_331
  end

  test "2: It finds the 3 numbers that sum up to 2020" do
    {:ok, {number_1, number_2, number_3}} = ExpenseReport.find_sum_of_3_numbers(@input)

    assert number_1 + number_2 + number_3 == 2020
    assert number_1 * number_2 * number_3 == 283_025_088
  end
end
