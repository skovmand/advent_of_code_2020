defmodule Advent20.ShuttleTest do
  use ExUnit.Case, async: true

  alias Advent20.Shuttle

  @input "13_shuttle.txt" |> Path.expand("input_files") |> File.read!()

  @unit_test_input """
  939
  7,13,x,x,59,x,31,19
  """

  describe "1" do
    test "unit test" do
      assert Shuttle.part_1(@unit_test_input) == 295
    end

    test "puzzle answer: id multiplied with waiting time" do
      assert Shuttle.part_1(@input) == 115
    end
  end
end
