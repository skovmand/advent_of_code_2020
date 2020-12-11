defmodule Advent20.SeatingSystemTest do
  use ExUnit.Case

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
      assert SeatingSystem.simulate_seating_area(@unit_test_input) == 37
    end

    test "puzzle answer: how many seats end up occupied?" do
      assert SeatingSystem.simulate_seating_area(@input) == 2275
    end
  end
end
