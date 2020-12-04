defmodule Advent20.Passport do
  @moduledoc """
  Day 4: Passport Processing
  """

  @doc """
  Part A
  """
  def count_valid_passports(passport_input_lists) do
    passport_input_lists
    |> Stream.map(&create_passport/1)
    |> Enum.count(&valid_passport?/1)
  end

  defp create_passport(password_input_list) do
    password_input_list
    |> Enum.reduce(%{}, fn input, passport ->
      [field, value] = String.split(input, ":")
      Map.put(passport, field, value)
    end)
  end

  defp valid_passport?(%{} = passport) do
    ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    |> Enum.all?(&Map.has_key?(passport, &1))
  end

  defmodule Passport do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field(:byr, :integer)
      field(:iyr, :integer)
      field(:eyr, :integer)
      field(:hgt, :string)
      field(:hcl, :string)
      field(:ecl, :string)
      field(:pid, :string)
      field(:cid, :string)
    end

    def changeset(params) do
      %__MODULE__{}
      |> cast(params, [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid])
      |> validate_required([:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid])
    end

    def extended_validation(changeset) do
      changeset
      |> validate_number(:byr, greater_than_or_equal_to: 1920, less_than_or_equal_to: 2002)
      |> validate_number(:iyr, greater_than_or_equal_to: 2010, less_than_or_equal_to: 2020)
      |> validate_number(:eyr, greater_than_or_equal_to: 2020, less_than_or_equal_to: 2030)
      |> validate_height(:hgt)
      |> validate_hair_color(:hcl)
      |> validate_inclusion(:ecl, ~w[amb blu brn gry grn hzl oth])
      |> validate_length(:pid, is: 9)
      |> validate_password_is_only_numbers(:pid)
    end

    defp validate_height(changeset, field) do
      input = fetch_field!(changeset, field)

      valid? =
        case Regex.run(~r/(\d+)(cm|in)/, input, capture: :all_but_first) do
          [height, "cm"] ->
            int_height = String.to_integer(height)
            int_height >= 150 and int_height <= 193

          [height, "in"] ->
            int_height = String.to_integer(height)
            int_height >= 59 and int_height <= 76

          _ ->
            false
        end

      if(not valid?, do: changeset |> add_error(field, "not valid"), else: changeset)
    end

    defp validate_hair_color(changeset, field) do
      valid? =
        case fetch_field!(changeset, field) do
          "#" <> value -> String.length(value) == 6
          _ -> false
        end

      if(not valid?, do: changeset |> add_error(field, "not valid"), else: changeset)
    end

    defp validate_password_is_only_numbers(changeset, field) do
      input = fetch_field!(changeset, field)
      valid? = Regex.match?(~r/^\d{9}$/, input)

      if(not valid?, do: changeset |> add_error(field, "not valid"), else: changeset)
    end
  end

  @doc """
  Part B
  """
  def count_valid_passports_strict(passport_input_lists) do
    passport_input_lists
    |> Stream.map(&create_passport/1)
    |> Stream.map(&Passport.changeset/1)
    |> Stream.filter(& &1.valid?)
    |> Stream.map(&Passport.extended_validation/1)
    |> Enum.count(& &1.valid?)
  end
end
