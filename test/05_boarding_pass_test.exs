defmodule Advent20.BoardingPassTest do
  use ExUnit.Case

  alias Advent20.BoardingPass

  @input_filename Path.expand("05_boarding_pass.txt", "input_files")

  describe "A: Unit tests" do
    test "BFFFBBFRRR" do
      assert BoardingPass.position_and_id("BFFFBBFRRR") == %{row: 70, column: 7, seat_id: 567}
    end

    test "FFFBBBFRRR" do
      assert BoardingPass.position_and_id("FFFBBBFRRR") == %{row: 14, column: 7, seat_id: 119}
    end

    test "BBFFBBFRLL" do
      assert BoardingPass.position_and_id("BBFFBBFRLL") == %{row: 102, column: 4, seat_id: 820}
    end
  end

  test "A: Highest seat ID on a boarding pass" do
    assert BoardingPass.highest_seat_id(@input_filename) == 832
  end

  test "B: Find own seat id" do
    assert BoardingPass.find_own_seat_id(@input_filename) == 517
  end
end
