defmodule Advent20.BagsTest do
  use ExUnit.Case

  alias Advent20.Bags

  @input_filename "07_bags.txt" |> Path.expand("input_files") |> File.read!()

  describe "A" do
    test "Unit test" do
      input = """
      light red bags contain 1 bright white bag, 2 muted yellow bags.
      dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      bright white bags contain 1 shiny gold bag.
      muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      faded blue bags contain no other bags.
      dotted black bags contain no other bags.
      """

      assert Bags.bags_eventually_containing_one_shiny_gold_bag(input) == 4
    end

    test "A: it sums unique group yes answers" do
      assert Bags.bags_eventually_containing_one_shiny_gold_bag(@input_filename) == 248
    end
  end

  @tag :skip
  test "B: ?" do
  end
end
