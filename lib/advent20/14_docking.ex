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
    |> Enum.reduce(state, fn instruction, state -> exec(instruction, state) end)
    |> Map.fetch!(:memory)
    |> Map.values()
    |> Enum.sum()
  end

  defp exec({:mask, new_mask}, state), do: %{state | bitmask: new_mask}

  defp exec({:mem, address, value}, state) do
    value_bits = value |> Integer.to_string(2) |> String.pad_leading(36, "0") |> String.codepoints()

    masked_value =
      state.bitmask
      |> String.codepoints()
      |> Enum.zip(value_bits)
      |> Enum.map(fn
        {"X", bit} -> bit
        {"0", _} -> "0"
        {"1", _} -> "1"
      end)
      |> Enum.join()
      |> String.to_integer(2)

    %{state | memory: Map.put(state.memory, address, masked_value)}
  end

  @doc """
  Part 2: Execute the initialization program using an emulator for a version 2
  decoder chip. What is the sum of all values left in memory after it completes?
  """
  def part_2(input) do
    program = input |> parse()

    state = %{
      bitmask: nil,
      memory: %{}
    }

    program
    |> Enum.reduce(state, fn instruction, state -> exec_v2(instruction, state) end)
    |> Map.fetch!(:memory)
    |> Map.values()
    |> Enum.sum()
  end

  defp exec_v2({:mask, new_mask}, state), do: %{state | bitmask: new_mask}

  defp exec_v2({:mem, address, value}, state) do
    address_bits = address |> Integer.to_string(2) |> String.pad_leading(36, "0") |> String.codepoints()

    state.bitmask
    |> String.codepoints()
    |> Enum.zip(address_bits)
    |> Enum.map(fn
      {"0", bit} -> bit
      {"1", _} -> "1"
      {"X", _} -> :floating
    end)
    |> Enum.reduce([""], fn
      :floating, acc ->
        acc_1 = acc |> Enum.map(&(&1 <> "0"))
        acc_2 = acc |> Enum.map(&(&1 <> "1"))
        acc_1 ++ acc_2

      char, acc ->
        Enum.map(acc, &(&1 <> char))
    end)
    |> Enum.map(&String.to_integer(&1, 2))
    |> Enum.reduce(state, fn address, state ->
      %{state | memory: Map.put(state.memory, address, value)}
    end)
  end
end
