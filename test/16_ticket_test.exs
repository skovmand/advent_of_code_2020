defmodule Advent20.TicketTest do
  use ExUnit.Case, async: true

  alias Advent20.Ticket

  @input "16_ticket.txt" |> Path.expand("input_files") |> File.read!()

  describe "1" do
    test "unit test" do
      input = """
      class: 1-3 or 5-7
      row: 6-11 or 33-44
      seat: 13-40 or 45-50

      your ticket:
      7,1,14

      nearby tickets:
      7,3,47
      40,4,50
      55,2,20
      38,6,12
      """

      assert Ticket.part_1(input) == 71
    end

    test "puzzle answer: ticket scanning error rate" do
      assert Ticket.part_1(@input) == 26941
    end
  end

  describe "2" do
    test "puzzle answer: departure fields multiplied" do
      assert Ticket.part_2(@input) == 634_796_407_951
    end
  end
end
