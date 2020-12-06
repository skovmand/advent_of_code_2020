defmodule Advent20.Customs do
  @moduledoc """
  Day 6: Custom Customs
  """

  @doc """
  Count yes answers for all groups
  """
  def count_yes_answer_sum_for_all_groups(group_answers) do
    group_answers
    |> Stream.map(&count_yes_answer_sum/1)
    |> Enum.sum()
  end

  defp count_yes_answer_sum(group_answer) do
    group_answer
    |> Stream.flat_map(&String.codepoints/1)
    |> Stream.uniq()
    |> Enum.count()
  end
end
