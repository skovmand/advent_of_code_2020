defmodule Advent20.OperationOrderTest do
  use ExUnit.Case, async: true

  import Advent20.OperationOrder

  @input "18_operation_order.txt" |> Path.expand("input_files") |> File.read!()

  describe "1" do
    test "postfix test" do
      assert "2*3+(4*5)" |> parse() |> List.first() |> tokenize() |> to_postfix() |> Enum.join() == "23*45*+"

      assert "5+(8*3+9+3*4*3)" |> parse() |> List.first() |> tokenize() |> to_postfix() |> Enum.join() ==
               "583*9+3+4*3*+"
    end

    test "unit tests" do
      assert part_1("2 * 3 + (4 * 5)") == 26
      assert part_1("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 437
      assert part_1("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 12240
      assert part_1("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 13632
    end

    test "puzzle answer: sum of the resulting values" do
      assert part_1(@input) == 11297104473091
    end
  end
end
