defmodule Advent20.PassportTest do
  use ExUnit.Case

  alias Advent20.Passport

  @passports "04_passports.txt"
             |> Path.expand("input_files")
             |> File.read!()
             |> String.split("\n")
             |> Enum.chunk_by(&(&1 == ""))
             |> Enum.reject(& &1 == [""])
             |> Enum.map(fn raw_passport ->
               Enum.flat_map(raw_passport, fn line -> String.split(line, " ") end)
             end)

  test "A: it counts valid passports" do
    assert Passport.count_valid_passports(@passports) == 170
  end
end
