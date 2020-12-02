defmodule Advent20.ExpenseReport do
  @doc """
  Find the first match of two numbers in a list of numbers
  that add up to a given sum
  """
  def find_sum_2(numbers, sum) do
    number_set = MapSet.new(numbers)

    first_number =
      Enum.find(numbers, fn number ->
        looking_for = sum - number
        MapSet.member?(number_set, looking_for)
      end)

    second_number = sum - first_number

    {first_number, second_number}
  end
end
