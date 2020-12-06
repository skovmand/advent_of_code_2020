defmodule Advent20.CustomsTest do
  use ExUnit.Case

  alias Advent20.Customs

  test "A: it sums unique group yes answers" do
    assert Customs.count_yes_answer_sum_for_all_groups() == 6885
  end

  test "B: it sums group answers where everyone agrees" do
    assert Customs.count_yes_answer_sum_total_agreement_all_groups() == 3550
  end
end
