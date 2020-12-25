defmodule Advent20.ComboBreakerTest do
  use ExUnit.Case, async: true

  alias Advent20.ComboBreaker

  @input "25_combo_breaker.txt" |> Path.expand("input_files") |> File.read!()

  describe "1" do
    test "transform_subject_number" do
      ComboBreaker.Cache.start_link()

      # Calculate public key for the card
      assert Advent20.ComboBreaker.transform_subject_number(7, 8) == 5_764_801

      # Calculate public key for the door
      assert Advent20.ComboBreaker.transform_subject_number(7, 11) == 17_807_724

      # Use cards public key and door loop size to get encryption key
      assert Advent20.ComboBreaker.transform_subject_number(5_764_801, 11) == 14_897_079

      # Use cards public key and door loop size to get encryption key
      assert Advent20.ComboBreaker.transform_subject_number(17_807_724, 8) == 14_897_079
    end

    test "unit test" do
      input = """
      5764801
      17807724
      """

      assert ComboBreaker.part_1(input) == 14_897_079
    end

    test "puzzle answer" do
      assert ComboBreaker.part_1(@input) == 9_177_528
    end
  end
end
