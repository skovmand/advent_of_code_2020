defmodule Advent20.GameConsoleTest do
  use ExUnit.Case

  alias Advent20.GameConsole

  @input "08_game_console.txt" |> Path.expand("input_files") |> File.read!()

  describe "1" do
    test "unit test" do
      input = """
      nop +0
      acc +1
      jmp +4
      acc +3
      jmp -3
      acc -99
      acc +1
      jmp -4
      acc +6
      """

      assert GameConsole.acc_value_after_first_loop(input) == 5
    end

    test "finds value after first loop" do
      assert GameConsole.acc_value_after_first_loop(@input) == 1200
    end
  end

  describe "2" do
    test "unit test" do
      input = """
      nop +0
      acc +1
      jmp +4
      acc +3
      jmp -3
      acc -99
      acc +1
      jmp -4
      acc +6
      """

      assert GameConsole.acc_value_at_program_termination(input) == 8
    end

    test "finds the value where the program terminates" do
      assert GameConsole.acc_value_at_program_termination(@input) == 1023
    end
  end
end
