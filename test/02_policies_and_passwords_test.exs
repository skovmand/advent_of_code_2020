defmodule Advent20.PoliciesAndPasswordsTest do
  use ExUnit.Case

  alias Advent20.PoliciesAndPasswords

  @passwords "02_policies_and_passwords.txt"
             |> Path.expand("input_files")
             |> File.stream!()

  test "A: Counts valid passwords" do
    assert PoliciesAndPasswords.count_valid_passwords(@passwords) == 469
  end

  test "B: Counts valid passwords with the correct policy" do
    assert PoliciesAndPasswords.count_valid_passwords_with_2nd_policy(@passwords) == 267
  end
end
