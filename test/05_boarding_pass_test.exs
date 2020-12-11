defmodule Advent20.BoardingPassTest do
  use ExUnit.Case, async: true

  alias Advent20.BoardingPass

  @input_filename Path.expand("05_boarding_pass.txt", "input_files")

  describe "1" do
    test "unit tests" do
      assert BoardingPass.position_and_id("BFFFBBFRRR") == %{row: 70, column: 7, seat_id: 567}
      assert BoardingPass.position_and_id("FFFBBBFRRR") == %{row: 14, column: 7, seat_id: 119}
      assert BoardingPass.position_and_id("BBFFBBFRLL") == %{row: 102, column: 4, seat_id: 820}
    end

    test "puzzle answer: find highest seat id" do
      assert BoardingPass.highest_seat_id(@input_filename) == 832
    end
  end

  describe "2" do
    test "puzzle answer: find your own seat id" do
      assert BoardingPass.find_own_seat_id(@input_filename) == 517
    end
  end
end
