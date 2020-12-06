defmodule Advent20.CustomsTest do
  use ExUnit.Case

  alias Advent20.Customs

  @answers "06_customs.txt"
           |> Path.expand("input_files")
           |> File.stream!()
           |> Stream.map(&String.trim/1)
           |> Stream.chunk_by(&(&1 == ""))
           |> Enum.reject(&(&1 == [""]))

  test "A: it sums unique group yes answers" do
    assert Customs.count_yes_answer_sum_for_all_groups(@answers) == 6885
  end

  test "B: it sums group answers where everyone agrees" do
    assert Customs.count_yes_answer_sum_total_agreement_all_groups(@answers) == 3550
  end
end
