defmodule Advent20.EncodingTest do
  use ExUnit.Case, async: true

  alias Advent20.Encoding

  @input "09_encoding.txt" |> Path.expand("input_files") |> File.read!()

  @unit_test_input """
  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576
  """

  describe "1" do
    test "unit test" do
      assert Encoding.first_failing_number(@unit_test_input, 5) == 127
    end

    test "puzzle answer: first number not summed by 2 numbers in preamble" do
      assert Encoding.first_failing_number(@input, 25) == 18_272_118
    end
  end

  describe "2" do
    test "unit test" do
      assert Encoding.contigous_set_for_number(@unit_test_input, 127) == 62
    end

    test "puzzle answer: smallest and largest contiguous number sum" do
      assert Encoding.contigous_set_for_number(@input, 18_272_118) == 2_186_361
    end
  end
end
