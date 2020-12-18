defmodule Advent20.OperationOrderTest do
  use ExUnit.Case, async: true

  import Advent20.OperationOrder

  @input "18_operation_order.txt" |> Path.expand("input_files") |> File.read!()

  describe "1" do
    test "postfix test" do
      to_postfix_string = fn input, precedences ->
        input
        |> parse()
        |> List.first()
        |> tokenize()
        |> to_postfix(precedences)
        |> Enum.join()
      end

      assert to_postfix_string.("2*3+(4*5)", %{*: 1, +: 1}) == "23*45*+"
      assert to_postfix_string.("2*3+(4*5)", %{*: 2, +: 1}) == "23*45*+"
      assert to_postfix_string.("5+(8*3+9+3*4*3)", %{*: 1, +: 1}) == "583*9+3+4*3*+"
      assert to_postfix_string.("5+(8*3+9+3*4*3)", %{*: 2, +: 1}) == "583*9+34*3*++"
    end

    test "unit tests" do
      assert part_1("2 * 3 + (4 * 5)") == 26
      assert part_1("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 437
      assert part_1("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 12240
      assert part_1("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 13632
    end

    test "puzzle answer: sum of the resulting values" do
      assert part_1(@input) == 11_297_104_473_091
    end
  end

  describe "2" do
    test "unit tests" do
      assert part_2("1 + (2 * 3) + (4 * (5 + 6))") == 51
      assert part_2("2 * 3 + (4 * 5)") == 46
      assert part_2("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 1445
      assert part_2("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 669_060
      assert part_2("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 23340
    end

    test "puzzle answer: sum of the resulting values" do
      assert part_2(@input) == 185_348_874_183_674
    end
  end
end
