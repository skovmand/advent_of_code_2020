defmodule Advent20.BagsTest do
  use ExUnit.Case

  alias Advent20.Bags

  @input "07_bags.txt" |> Path.expand("input_files") |> File.read!()

  describe "1" do
    test "unit test" do
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

    test "puzzle answer: bags eventually containing one shiny gold bag" do
      assert Bags.bags_eventually_containing_one_shiny_gold_bag(@input) == 248
    end
  end

  describe "2" do
    test "unit test" do
      input = """
      shiny gold bags contain 2 dark red bags.
      dark red bags contain 2 dark orange bags.
      dark orange bags contain 2 dark yellow bags.
      dark yellow bags contain 2 dark green bags.
      dark green bags contain 2 dark blue bags.
      dark blue bags contain 2 dark violet bags.
      dark violet bags contain no other bags.
      """

      assert Bags.bags_inside_a_shiny_gold_bag(input) == 126
    end

    test "puzzle answer: count bags inside a shiny gold bag" do
      assert Bags.bags_inside_a_shiny_gold_bag(@input) == 57281
    end
  end
end
