defmodule Advent20.GameConsole do
  @moduledoc """
  Day 8: Handheld Halting
  """

  @doc """
  Run your copy of the boot code. Immediately before any instruction
  is executed a second time, what value is in the accumulator?
  """
  def acc_value_after_first_loop(input) do
    state = %{pointer: 0, acc: 0}

    input
    |> parse_input()
    |> run_program(state, MapSet.new())
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&Regex.run(~r/(.{3}) (.+)$/, &1, capture: :all_but_first))
    |> Stream.map(fn [instruction, string_value] -> {instruction, String.to_integer(string_value)} end)
    |> Stream.with_index()
    |> Stream.map(fn {value, index} -> {index, value} end)
    |> Enum.into(%{})
  end

  defp run_program(input, state, executed) do
    if MapSet.member?(executed, state.pointer) do
      state.acc
    else
      instruction = Map.fetch!(input, state.pointer)
      executed = MapSet.put(executed, state.pointer)
      state = apply_instruction(state, instruction)

      run_program(input, state, executed)
    end
  end

  defp apply_instruction(%{pointer: pointer} = state, {"nop", _}), do: %{state | pointer: pointer + 1}
  defp apply_instruction(%{pointer: pointer} = state, {"jmp", jmp}), do: %{state | pointer: pointer + jmp}

  defp apply_instruction(%{pointer: pointer, acc: acc} = state, {"acc", value}) do
    %{state | pointer: pointer + 1, acc: acc + value}
  end
end
