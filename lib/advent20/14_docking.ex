defmodule Advent20.Docking do
  @moduledoc """
  Day 14: Docking Data
  """

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " = "))
    |> Enum.map(fn
      ["mem" <> address_string, value] ->
        address = address_string |> String.replace(["[", "]"], "") |> String.to_integer()
        value = String.to_integer(value)
        {:mem, address, value}

      ["mask", mask] ->
        {:mask, mask}
    end)
  end

  @doc """
  Part 1: Execute the initialization program. What is the sum of all 
  values left in memory after it completes?
  """
  def part_1(input) do
    program = input |> parse()

    state = %{
      bitmask: nil,
      memory: %{}
    }

    program
    |> Enum.reduce(state, fn instruction, state ->
      state = exec(instruction, state)
    end)
    |> Map.fetch!(:memory)
    |> Map.values()
    |> Enum.sum()
  end

  defp exec({:mask, new_mask}, state), do: %{state | bitmask: new_mask}

  defp exec({:mem, position, value}, state) do
    binary_string = value |> Integer.to_string(2) |> String.pad_leading(36, "0") |> String.codepoints()

    masked_value =
      state.bitmask
      |> String.codepoints()
      |> Enum.zip(binary_string)
      |> Enum.map(fn
        {"X", bit} -> bit
        {"0", _} -> "0"
        {"1", _} -> "1"
      end)
      |> Enum.join()
      |> String.to_integer(2)

    %{state | memory: Map.put(state.memory, position, masked_value)}
  end
end
