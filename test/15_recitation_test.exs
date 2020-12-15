defmodule Advent20.RecitationTest do
  use ExUnit.Case, async: true

  alias Advent20.Recitation

  @input "15_recitation.txt" |> Path.expand("input_files") |> File.read!() |> String.trim()

  describe "1" do
    test "example" do
      assert Recitation.solve("0,3,6", 2020) == 436
    end

    test "unit test" do
      assert Recitation.solve("1,3,2", 2020) == 1
      assert Recitation.solve("2,1,3", 2020) == 10
      assert Recitation.solve("1,2,3", 2020) == 27
      assert Recitation.solve("2,3,1", 2020) == 78
      assert Recitation.solve("3,2,1", 2020) == 438
      assert Recitation.solve("3,1,2", 2020) == 1836
    end

    test "puzzle answer: number spoken at 2020" do
      assert Recitation.solve(@input, 2020) == 249
    end
  end

  describe "2" do
    test "puzzle answer: number spoken at 30.000.000" do
      assert Recitation.solve(@input, 30_000_000) == 41687
    end
  end
end
