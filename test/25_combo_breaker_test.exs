defmodule Advent20.ComboBreakerTest do
  use ExUnit.Case, async: true

  alias Advent20.ComboBreaker

  @input "25_combo_breaker.txt" |> Path.expand("input_files") |> File.read!()

  describe "1" do
    test "unit test" do
      input = """
      5764801
      17807724
      """

      assert ComboBreaker.part_1(input) == 14_897_079
    end

    # The test runs in ~40 sec on my machine, but not on GitHub Actions, which needs a longer timeout
    test "puzzle answer" do
      assert ComboBreaker.part_1(@input) == 9_177_528
    end
  end
end
