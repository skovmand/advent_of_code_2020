defmodule Advent20.EncodingTest do
  use ExUnit.Case

  alias Advent20.Encoding

  @input "09_encoding.txt" |> Path.expand("input_files") |> File.read!()

  describe "part 1" do
    test "unit test" do
      input = """
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

      assert Encoding.first_failing_number(input, 5) == 127
    end

    test "puzzle answer" do
      assert Encoding.first_failing_number(@input, 25) == 18272118
    end
  end

  describe "part 2" do
    @tag :skip
    test "unit test" do
    end

    @tag :skip
    test "puzzle answer" do
      assert Encoding.first_failing_number(@input, 25) == nil
    end
  end
end
