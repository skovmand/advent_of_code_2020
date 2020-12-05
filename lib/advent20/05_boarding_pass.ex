defmodule Advent20.BoardingPass do
  @moduledoc """
  Day 5: Binary Boarding
  """

  @doc """
  A: Find highest seat id on a boarding pass
  """
  def highest_seat_id(boarding_pass_identifiers) do
    boarding_pass_identifiers
    |> Stream.map(&position_and_id/1)
    |> Stream.map(& &1.seat_id)
    |> Enum.max()
  end

  @doc """
  Calculate the row, column and seat id from the partitioning
  """
  def position_and_id(<<row::binary-size(7), column::binary-size(3)>>) do
    row = binary_partition(row)
    column = binary_partition(column)
    seat_id = row * 8 + column

    %{row: row, column: column, seat_id: seat_id}
  end

  defp binary_partition(input) do
    input
    |> String.codepoints()
    |> Enum.map(&prepare_input/1)
    |> parse_binary()
  end

  defp prepare_input("F"), do: 0
  defp prepare_input("L"), do: 0
  defp prepare_input("B"), do: 1
  defp prepare_input("R"), do: 1

  @doc """
  Parse a list of 0 and 1s into a base-10 number
  """
  def parse_binary(list, sum \\ 0)

  def parse_binary([0 | tail], sum), do: parse_binary(tail, sum)

  def parse_binary([1 | tail], sum) do
    exp = length(tail)
    sum = sum + :math.pow(2, exp)

    parse_binary(tail, sum)
  end

  def parse_binary([], sum), do: Kernel.trunc(sum)

  @doc """
  B: Find own seat id
  """
  def find_own_seat_id(boarding_pass_identifiers) do
    boarding_pass_seat_ids =
      boarding_pass_identifiers
      |> Stream.map(&position_and_id/1)
      |> Stream.map(& &1.seat_id)
      |> MapSet.new()

    all_seats_ids = MapSet.new(0..(8 * 128 - 1))

    missing_boarding_passes =
      Enum.reduce(boarding_pass_seat_ids, all_seats_ids, fn seat_id, seat_set ->
        MapSet.delete(seat_set, seat_id)
      end)

    Enum.find(missing_boarding_passes, fn seat_id ->
      MapSet.member?(boarding_pass_seat_ids, seat_id - 1) and
        MapSet.member?(boarding_pass_seat_ids, seat_id + 1)
    end)
  end
end
