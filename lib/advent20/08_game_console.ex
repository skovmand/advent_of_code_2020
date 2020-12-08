defmodule Advent20.GameConsole do
  @moduledoc """
  Day 8: Handheld Halting
  """

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&Regex.run(~r/(.{3}) (.+)$/, &1, capture: :all_but_first))
    |> Stream.map(fn [instruction, string_value] -> {instruction, String.to_integer(string_value)} end)
    |> Stream.with_index()
    |> Stream.map(fn {value, index} -> {index, value} end)
    |> Enum.into(%{})
  end

  @doc """
  1: Run your copy of the boot code. Immediately before any instruction
     is executed a second time, what value is in the accumulator?
  """
  def acc_value_after_first_loop(input) do
    state = %{pointer: 0, acc: 0}

    {:loop, acc, _} =
      input
      |> parse_input()
      |> run_program(state, MapSet.new())

    acc
  end

  @doc """
  2: What is the value of the accumulator after the program terminates?
  """
  def acc_value_at_program_termination(input) do
    state = %{pointer: 0, acc: 0}
    parsed_input = parse_input(input)

    # We know that the final instruction is the next instruction right after the boot code
    final_instruction = parsed_input |> Map.keys() |> Enum.max() |> Kernel.+(1)

    # Run the program once to get a trace of all instructions before the program loops
    {:loop, _acc, trace} =
      input
      |> parse_input()
      |> run_program(state, MapSet.new())

    # Generate all alternate versions of the program, find the one that terminates
    trace
    |> alternate_versions(parsed_input)
    |> Enum.find_value(fn input ->
      case run_program(input, state, MapSet.new()) do
        {:termination, acc, ^final_instruction} -> acc
        {:loop, _, _} -> false
      end
    end)
  end

  defp alternate_versions(trace, input) do
    Enum.flat_map(trace, fn pointer ->
      case Map.fetch!(input, pointer) do
        {"jmp", value} -> [Map.put(input, pointer, {"nop", value})]
        {"nop", value} -> [Map.put(input, pointer, {"jmp", value})]
        {"acc", _value} -> []
      end
    end)
  end

  defp run_program(input, state, executed, trace \\ []) do
    with {:looping?, false} <- {:looping?, MapSet.member?(executed, state.pointer)},
         {:get_instruction, {:ok, instruction}} <- {:get_instruction, Map.fetch(input, state.pointer)} do
      executed = MapSet.put(executed, state.pointer)
      trace = [state.pointer | trace]
      state = apply_instruction(state, instruction)

      run_program(input, state, executed, trace)
    else
      {:looping?, true} -> {:loop, state.acc, trace}
      {:get_instruction, :error} -> {:termination, state.acc, state.pointer}
    end
  end

  defp apply_instruction(%{pointer: pointer} = state, {"nop", _}), do: %{state | pointer: pointer + 1}
  defp apply_instruction(%{pointer: pointer} = state, {"jmp", jmp}), do: %{state | pointer: pointer + jmp}

  defp apply_instruction(%{pointer: pointer, acc: acc} = state, {"acc", value}) do
    %{state | pointer: pointer + 1, acc: acc + value}
  end
end
