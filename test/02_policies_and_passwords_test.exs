defmodule Advent20.PoliciesAndPasswordsTest do
  use ExUnit.Case, async: true

  alias Advent20.PoliciesAndPasswords

  @passwords_stream "02_policies_and_passwords.txt"
                    |> Path.expand("input_files")
                    |> File.stream!()

  test "1: Counts valid passwords" do
    assert PoliciesAndPasswords.count_valid_passwords(@passwords_stream) == 469
  end

  test "2: Counts valid passwords with the correct policy" do
    assert PoliciesAndPasswords.count_valid_passwords_with_2nd_policy(@passwords_stream) == 267
  end
end
