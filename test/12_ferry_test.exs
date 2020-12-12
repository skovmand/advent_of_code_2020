defmodule Advent20.FerryTest do
  use ExUnit.Case, async: true

  alias Advent20.Ferry

  @input "12_ferry.txt" |> Path.expand("input_files") |> File.read!()

  @unit_test_input """
  F10
  N3
  F7
  R90
  F11
  """

  describe "1" do
    test "unit test" do
      assert Ferry.part_1(@unit_test_input) == 25
    end

    test "puzzle answer: manhattan distance btw. location and start pos" do
      assert Ferry.part_1(@input) == 845
    end
  end
end
