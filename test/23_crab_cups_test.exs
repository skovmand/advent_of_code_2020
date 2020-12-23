defmodule Advent20.CrabCupsTest do
  use ExUnit.Case, async: true

  alias Advent20.CrabCups

  @input "23_crab_cups.txt" |> Path.expand("input_files") |> File.read!()

  describe "1" do
    test "unit test" do
      assert CrabCups.part_1("389125467") == "67384529"
    end

    test "puzzle answer" do
      assert CrabCups.part_1(@input) == "47598263"
    end
  end

  describe "2" do
    @tag timeout: 120_000
    test "unit test" do
      assert CrabCups.part_2("389125467") == 149_245_887_792
    end

    @tag timeout: 120_000
    test "puzzle answer" do
      assert CrabCups.part_2(@input) == 248_009_574_232
    end
  end
end
