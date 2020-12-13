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

  describe "2" do
    defp prepare(bus_ids) do
      Enum.join(["padding", bus_ids], "\n")
    end

    test "puzzle examples" do
      assert "17,x,13,19" |> prepare() |> Shuttle.part_2() == 3417
      assert "67,7,59,61" |> prepare() |> Shuttle.part_2() == 754_018
      assert "67,x,7,59,61" |> prepare() |> Shuttle.part_2() == 779_210
      assert "67,7,x,59,61" |> prepare() |> Shuttle.part_2() == 1_261_476
      assert "1789,37,47,1889" |> prepare() |> Shuttle.part_2() == 1_202_161_486
    end

    test "unit test" do
      assert Shuttle.part_2(@unit_test_input) == 1_068_781
    end

    test "puzzle answer: id multiplied with waiting time" do
      assert Shuttle.part_2(@input) == 756_261_495_958_122
    end
  end
end
