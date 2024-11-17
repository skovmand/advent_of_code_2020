input = Path.expand("01_expense_report.txt", "input_files") |> File.read!()

Benchee.run(%{
  "part1" => fn -> Advent20.ExpenseReport.find_sum_of_2_numbers(input) end
})

Benchee.run(%{
  "part2" => fn -> Advent20.ExpenseReport.find_sum_of_3_numbers(input) end
})
