defmodule Advent20.Util do
  def parse_to_number_list(input) do
    input
    |> String.split("\n", trim_whitespace: true)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
  end

  def read_from_stdin() do
    IO.read(:stdio, :eof)
  end

  def print_solution(day, part, solution) do
    IO.puts("Day #{day}, part #{part}:")
    IO.puts(solution)
  end
end
