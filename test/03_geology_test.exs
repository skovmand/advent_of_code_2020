defmodule Advent20.TreesTest do
  use ExUnit.Case, async: true

  alias Advent20.Geology

  @input_filename Path.expand("03_geology.txt", "input_files")

  test "1: Count trees encountered with slope right 3, 1 down" do
    assert Geology.count_trees(@input_filename, {3, 1}) == 162
  end

  test "2: Calculate product of multiple slopes" do
    slopes = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    assert Geology.multiple_slope_tree_count_product(@input_filename, slopes) == 3_064_612_320
  end
end
