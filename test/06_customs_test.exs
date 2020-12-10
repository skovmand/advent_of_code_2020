defmodule Advent20.CustomsTest do
  use ExUnit.Case

  alias Advent20.Customs

  @input_file "06_customs.txt" |> Path.expand("input_files")

  test "1: it sums unique group yes answers" do
    assert Customs.count_yes_answer_sum_for_all_groups(@input_file) == 6885
  end

  test "2: it sums group answers where everyone agrees" do
    assert Customs.count_yes_answer_sum_total_agreement_all_groups(@input_file) == 3550
  end
end
