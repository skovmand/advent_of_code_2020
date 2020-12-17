defmodule Advent20.CubesTest do
  use ExUnit.Case, async: true

  alias Advent20.Cubes

  @input "17_cubes.txt" |> Path.expand("input_files") |> File.read!()

  @unit_test_input """
  .#.
  ..#
  ###
  """

  describe "1" do
    test "unit test" do
      assert Cubes.part_1(@unit_test_input) == 112
    end

    test "puzzle answer: how many cubes left after 6th cycle" do
      assert Cubes.part_1(@input) == 252
    end
  end

  describe "2" do
    test "unit test" do
      assert Cubes.part_2(@unit_test_input) == 848
    end

    test "puzzle answer: how many cubes left after 6th cycle" do
      assert Cubes.part_2(@input) == 2160
    end
  end
end
