defmodule Advent20.CrabCombatTest do
  use ExUnit.Case, async: true

  alias Advent20.CrabCombat

  @input "22_crab_combat.txt" |> Path.expand("input_files") |> File.read!()

  describe "1" do
    test "unit test" do
      input = """
      Player 1:
      9
      2
      6
      3
      1

      Player 2:
      5
      8
      4
      7
      10
      """

      assert CrabCombat.part_1(input) == 306
    end

    test "puzzle answer: winning player score" do
      assert CrabCombat.part_1(@input) == 32856
    end
  end
end
