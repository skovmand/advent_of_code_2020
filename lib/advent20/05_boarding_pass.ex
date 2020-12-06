defmodule Advent20.BoardingPass do
  @moduledoc """
  Day 5: Binary Boarding
  """

  # Set up a stream of boarding pass identifiers
  defp boarding_pass_identifier_stream(input_filename) do
    input_filename
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  @doc """
  Part 1: Find highest seat id on a boarding pass
  """
  def highest_seat_id(input_filename) do
    boarding_pass_identifier_stream(input_filename)
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

  # Turns our that binary partitioning follows the binary number system exactly
  # we can just parse the boarding passes as binary numbers
  defp binary_partition(input) do
    input
    |> String.replace(["F", "L"], "0")
    |> String.replace(["B", "R"], "1")
    |> String.to_integer(2)
  end

  @doc """
  Part 2: Find your own seat id
  """
  def find_own_seat_id(input_filename) do
    boarding_pass_seat_ids =
      boarding_pass_identifier_stream(input_filename)
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
