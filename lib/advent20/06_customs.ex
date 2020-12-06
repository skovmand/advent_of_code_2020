defmodule Advent20.Customs do
  @moduledoc """
  Day 6: Custom Customs
  """

  # Read an input file and set an answer stream up
  defp answer_stream(input_filename) do
    input_filename
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_by(&(&1 == ""))
    |> Stream.reject(&(&1 == [""]))
  end

  @doc """
  Part 1: Count yes answers for all groups
  """
  def count_yes_answer_sum_for_all_groups(input_filename) do
    answer_stream(input_filename)
    |> Stream.map(&count_yes_answer_sum/1)
    |> Enum.sum()
  end

  defp count_yes_answer_sum(group_answer) do
    group_answer
    |> Stream.flat_map(&String.codepoints/1)
    |> Stream.uniq()
    |> Enum.count()
  end

  @doc """
  Part 2: Count the sum of yes answers where everyone in the group agrees, for all groups
  """
  def count_yes_answer_sum_total_agreement_all_groups(input_filename) do
    answer_stream(input_filename)
    |> Stream.map(&count_agreeing_answers/1)
    |> Enum.sum()
  end

  def count_agreeing_answers(group_answer) do
    group_answer
    |> Stream.map(&String.codepoints/1)
    |> Stream.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> Enum.count()
  end
end
