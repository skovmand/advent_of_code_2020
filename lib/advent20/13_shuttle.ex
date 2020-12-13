defmodule Advent20.Shuttle do
  @moduledoc """
  Day 13: Shuttle Search
  """

  defp parse_part_1(input) do
    [earliest_departure, bus_ids] = String.split(input, "\n", trim: true)

    %{
      earliest_departure: String.to_integer(earliest_departure),
      bus_ids: bus_ids |> String.split(",") |> Enum.reject(&(&1 == "x")) |> Enum.map(&String.to_integer/1)
    }
  end

  @doc """
  Part 1: What is the ID of the earliest bus you can take to the airport
  multiplied by the number of minutes you'll need to wait for that bus?
  """
  def part_1(input) do
    input
    |> parse_part_1()
    |> earliest_bus_id_multiplied()
  end

  def earliest_bus_id_multiplied(%{earliest_departure: earliest_departure, bus_ids: bus_ids}) do
    bus_ids
    |> Enum.map(fn id -> {id, id - rem(earliest_departure, id)} end)
    |> Enum.min_by(fn {_id, minutes} -> minutes end)
    |> (fn {id, minutes} -> id * minutes end).()
  end

  defp parse_part_2(input) do
    String.split(input, "\n", trim: true)
    |> Enum.at(1)
    |> String.split(",")
    |> Enum.map(fn
      "x" -> :x
      bus_id -> String.to_integer(bus_id)
    end)
    |> Enum.with_index()
    |> Enum.reject(&(elem(&1, 0) == :x))
  end

  @doc """
  What is the earliest timestamp such that all of the listed bus IDs depart at
  offsets matching their positions in the list?

  From the unit test we get these congruences. At t bus 7 leaves, at t+1 bus 13 leaves,
  at t+4 bus 59 leaves, and so on. So we can make these congruences:

  t≡0 (mod 7)
  t+1≡0 (mod 13)
  t+4≡0 (mod 59)
  t+6≡0 (mod 31)
  t+7≡0 (mod 19)

  Which is equivalent to the cleaner form (using a remainder of `bus_id - offset`):

  t≡0 (mod 7)
  t≡12 (mod 13)
  t≡55 (mod 59)
  t≡25 (mod 31)
  t≡12 (mod 19)
  """
  def part_2(input) do
    input
    |> parse_part_2()
    |> Enum.map(fn {bus_id, offset} -> {bus_id, bus_id - offset} end)
    |> gold_star_competition()
  end

  # Video reference: https://www.youtube.com/watch?v=zIFehsBHB8o
  defp gold_star_competition(buses) do
    # The period (N in the chinese theorem), is the product of all the bus ids (which are the modulos)
    period = buses |> Enum.map(&elem(&1, 0)) |> Enum.reduce(&Kernel.*/2)

    # All pairs of modulos must have a gcd of 1, in other words, be pairwise prime
    true =
      buses
      |> Enum.map(&elem(&1, 0))
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.all?(fn [mod_1, mod_2] -> gcd(mod_1, mod_2) == 1 end)

    # Run the Chinese Remainder algorithm to find the x that solves all our congruences
    x =
      buses
      |> Enum.map(fn {bus_id, remainder} ->
        # Ni in the chinese remainder theorem is found by dividing
        # N (the period) with the modulus (the bus id)
        ni = div(period, bus_id)

        # Next, find the inverse of Ni
        # if for example Ni is 40 and the modulus is 7, we have to
        # find the number x for which e.g. 40x≡1 (mod 7)
        xi = calculate_xi(ni, bus_id)

        ni * xi * remainder
      end)
      |> Enum.sum()

    # Uncomment to see the actual numbers:
    # IO.puts("We need to find an x that will solve:")
    # buses |> Enum.each(fn {id, offset} -> IO.puts("x≡#{offset} (mod #{id})") end)
    # IO.puts("Found x: x≡#{x} (mod #{period})")

    rem(x, period)
  end

  defp calculate_xi(ni, modulus) do
    # If ni is 40 and modulus is 7, start the search from a base number
    # in this case 5 can be used because 40x ≡ 1 (mod 7) is congruent with 5x ≡ 1 (mod 7)
    # (this is because 40 and 5 are congruent mod 7, their remainders are both 5)
    base = rem(ni, modulus)

    # Then start the search for an x where 5 * x (mod 7) == 1
    Stream.iterate(0, &(&1 + 1))
    |> Enum.find(fn value -> rem(base * value, modulus) == 1 end)
  end

  # Find the greatest common divisor for two numbers
  defp gcd(a, 0), do: abs(a)
  defp gcd(a, b), do: gcd(b, rem(a, b))
end
