defmodule Advent20.DockingTest do
  use ExUnit.Case, async: true

  alias Advent20.Docking

  @input "14_docking.txt" |> Path.expand("input_files") |> File.read!()

  @unit_test_input """
  mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  mem[8] = 11
  mem[7] = 101
  mem[8] = 0
  """

  describe "1" do
    test "unit test" do
      assert Docking.part_1(@unit_test_input) == 165
    end

    test "puzzle answer: sum of all values in memory" do
      assert Docking.part_1(@input) == 8_570_568_288_597
    end
  end
end
