defmodule Advent20.ExpenseReportTest do
  use ExUnit.Case

  alias Advent20.ExpenseReport

  @input_filename Path.expand("01_expense_report.txt", "input_files")

  test "A: It finds the 2 numbers that sum up to 2020" do
    {number_1, number_2} = ExpenseReport.find_sum_2(@input_filename, 2020)

    assert number_1 + number_2 == 2020
    assert number_1 * number_2 == 870_331
  end

  test "B: It finds the 3 numbers that sum up to 2020" do
    {number_1, number_2, number_3} = ExpenseReport.find_sum_3(@input_filename, 2020)

    assert number_1 + number_2 + number_3 == 2020
    assert number_1 * number_2 * number_3 == 283_025_088
  end
end
