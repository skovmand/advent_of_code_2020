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
    space = :math.pow(2, String.length(input)) |> Kernel.trunc()

    input
    |> String.codepoints()
    |> Enum.map(&prepare_input/1)
    |> do_binary_partition(1, space)
    |> Kernel.-(1)
  end

  defp prepare_input("F"), do: :lower
  defp prepare_input("L"), do: :lower
  defp prepare_input("B"), do: :upper
  defp prepare_input("R"), do: :upper

  defp do_binary_partition([:lower | tail], floor, ceil) do
    range = ceil - floor + 1
    do_binary_partition(tail, floor, ceil - range / 2)
  end

  defp do_binary_partition([:upper | tail], floor, ceil) do
    range = ceil - floor + 1
    do_binary_partition(tail, floor + range / 2, ceil)
  end

  defp do_binary_partition([], result, _result), do: Kernel.trunc(result)

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
