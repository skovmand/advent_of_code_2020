defmodule Advent20.TreesTest do
  use ExUnit.Case

  alias Advent20.Geology

  @geology "03_geology.txt"
           |> Path.expand("input_files")
           |> File.read!()
           |> String.split("\n", trim: true)

  test "A: Counts valid passwords" do
    assert Geology.count_trees(@geology, {3, 1}) == 162
  end

  test "B: Counts valid passwords with the correct policy" do
  end
end
