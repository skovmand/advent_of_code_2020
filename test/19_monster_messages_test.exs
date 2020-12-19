defmodule Advent20.MonsterMessagesTest do
  use ExUnit.Case, async: true

  alias Advent20.MonsterMessages

  @input "19_monster_messages.txt" |> Path.expand("input_files") |> File.read!()

  describe "1" do
    test "unit tests" do
      input = """
      0: 4 1 5
      1: 2 3 | 3 2
      2: 4 4 | 5 5
      3: 4 5 | 5 4
      4: "a"
      5: "b"

      ababbb
      bababa
      abbbab
      aaabbb
      aaaabbb
      """

      assert MonsterMessages.part_1(input) == 2
    end

    test "puzzle answer: valid message count" do
      assert MonsterMessages.part_1(@input) == 168
    end
  end
end
