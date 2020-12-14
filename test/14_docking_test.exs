defmodule Advent20.DockingTest do
  use ExUnit.Case, async: true

  alias Advent20.Docking

  @input "14_docking.txt" |> Path.expand("input_files") |> File.read!()

  describe "1" do
    test "unit test" do
      program = """
      mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
      mem[8] = 11
      mem[7] = 101
      mem[8] = 0
      """

      assert Docking.part_1(program) == 165
    end

    test "puzzle answer: sum of all values in memory" do
      assert Docking.part_1(@input) == 8_570_568_288_597
    end
  end

  describe "2" do
    test "unit test" do
      program = """
      mask = 000000000000000000000000000000X1001X
      mem[42] = 100
      mask = 00000000000000000000000000000000X0XX
      mem[26] = 1
      """

      assert Docking.part_2(program) == 208
    end

    test "puzzle answer: sum of all values in memory" do
      assert Docking.part_2(@input) == 3_289_441_921_203
    end
  end
end
