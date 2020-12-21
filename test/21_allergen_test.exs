defmodule Advent20.AllergenTest do
  use ExUnit.Case, async: true

  alias Advent20.Allergen

  @input "21_allergen.txt" |> Path.expand("input_files") |> File.read!()

  @unit_test_input """
  mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
  trh fvjkl sbzzf mxmxvkd (contains dairy)
  sqjhc fvjkl (contains soy)
  sqjhc mxmxvkd sbzzf (contains fish)
  """

  describe "1" do
    test "unit test" do
      assert Allergen.part_1(@unit_test_input) == 5
    end

    test "puzzle answer" do
      assert Allergen.part_1(@input) == 1885
    end
  end

  describe "2" do
    test "unit test" do
      assert Allergen.part_2(@unit_test_input) == "mxmxvkd,sqjhc,fvjkl"
    end

    test "puzzle answer" do
      assert Allergen.part_2(@input) == "fllssz,kgbzf,zcdcdf,pzmg,kpsdtv,fvvrc,dqbjj,qpxhfp"
    end
  end
end
