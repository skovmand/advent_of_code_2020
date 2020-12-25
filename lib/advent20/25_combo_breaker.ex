defmodule Advent20.ComboBreaker do
  @moduledoc """
  --- Day 25: Combo Breaker ---
  """

  defmodule Cache do
    use Agent

    def start_link() do
      Agent.start_link(fn -> %{} end, name: __MODULE__)
    end

    def get(key) do
      Agent.get(__MODULE__, &Map.fetch(&1, key))
    end

    def put(key, value) do
      Agent.update(__MODULE__, &Map.put(&1, key, value))
    end
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  # Blarh, it turns out Elixir has no :math.pow/3 as Pythons pow/3:
  #
  # From python 3.9 docs: pow(base, exp, [mod]): Return base to the power exp;
  # if mod is present, return base to the power exp, modulo mod (computed more
  # efficiently than pow(base, exp) % mod)
  #
  # I have made a quickfix to this by making a cache
  def part_1(input) do
    Cache.start_link()
    pubkeys = parse(input)

    {loop_size_1, pubkey_1} =
      Stream.iterate(1, &(&1 + 1))
      |> Stream.map(fn loop_size -> {loop_size, transform_subject_number(7, loop_size)} end)
      |> Enum.find(fn {_loop_size, pubkey} -> pubkey in pubkeys end)

    [other_pubkey] = Enum.reject(pubkeys, &(&1 == pubkey_1))

    transform_subject_number(other_pubkey, loop_size_1)
  end

  def transform_subject_number(subject_number, loop_size) do
    result =
      case Cache.get({subject_number, loop_size - 1}) do
        {:ok, prev_result} ->
          rem(prev_result * subject_number, 20_201_227)

        :error ->
          calculate_transform_subject_number(subject_number, loop_size)
      end

    Cache.put({subject_number, loop_size}, result)
    result
  end

  def calculate_transform_subject_number(subject_number, loop_size) do
    Stream.iterate(1, &rem(&1 * subject_number, 20_201_227))
    |> Enum.at(loop_size)
  end
end
