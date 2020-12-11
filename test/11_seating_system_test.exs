defmodule Advent20.SeatingSystemTest do
  use ExUnit.Case, async: true

  alias Advent20.SeatingSystem

  @input "11_seating_system.txt" |> Path.expand("input_files") |> File.read!()

  @unit_test_input """
  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL
  """

  describe "1" do
    test "unit test" do
      assert SeatingSystem.part_1(@unit_test_input) == 37
    end

    test "puzzle answer: how many seats end up occupied?" do
      assert SeatingSystem.part_1(@input) == 2275
    end
  end

  describe "2" do
    test "unit test" do
      assert SeatingSystem.part_2(@unit_test_input) == 26
    end

    test "puzzle answer: how many seats end up occupied?" do
      assert SeatingSystem.part_2(@input) == 2121
    end
  end
end
