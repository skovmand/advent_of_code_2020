defmodule Advent20.PassportTest do
  use ExUnit.Case, async: true

  alias Advent20.Passport

  @input_filename Path.expand("04_passports.txt", "input_files")

  test "1: it counts valid passports" do
    assert Passport.count_valid_passports(@input_filename) == 170
  end

  test "2: it counts valid passports with strict rules" do
    assert Passport.count_valid_passports_strict(@input_filename) == 103
  end
end
