defmodule Advent20.AdapterTest do
  use ExUnit.Case

  alias Advent20.Adapter

  @input "10_adapter.txt" |> Path.expand("input_files") |> File.read!()

  describe "part 1" do
    test "unit test" do
      input = """
      28
      33
      18
      42
      31
      14
      46
      20
      48
      47
      24
      23
      49
      45
      19
      38
      39
      11
      1
      32
      25
      35
      8
      17
      7
      9
      4
      2
      34
      10
      3
      """

      assert Adapter.jolt_differences(input) == 220
    end

    test "puzzle answer" do
      assert Adapter.jolt_differences(@input) == 1917
    end
  end
end
