defmodule Advent20.AdapterTest do
  use ExUnit.Case, async: true

  alias Advent20.Adapter

  @input "10_adapter.txt" |> Path.expand("input_files") |> File.read!()

  @unit_test_input """
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

  describe "1" do
    test "unit test" do
      assert Adapter.jolt_differences(@unit_test_input) == 220
    end

    test "puzzle answer: product of 1 and 3 jolt differences" do
      assert Adapter.jolt_differences(@input) == 1917
    end
  end

  describe "2" do
    test "unit test" do
      assert Adapter.adapter_combinations(@unit_test_input) == 19208
    end

    test "puzzle answer: count possible paths" do
      assert Adapter.adapter_combinations(@input) == 113_387_824_750_592
    end
  end
end
