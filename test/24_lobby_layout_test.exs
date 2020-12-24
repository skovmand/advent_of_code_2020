defmodule Advent20.LobbyLayoutTest do
  use ExUnit.Case, async: true

  alias Advent20.LobbyLayout

  @unit_test_input """
  sesenwnenenewseeswwswswwnenewsewsw
  neeenesenwnwwswnenewnwwsewnenwseswesw
  seswneswswsenwwnwse
  nwnwneseeswswnenewneswwnewseswneseene
  swweswneswnenwsewnwneneseenw
  eesenwseswswnenwswnwnwsewwnwsene
  sewnenenenesenwsewnenwwwse
  wenwwweseeeweswwwnwwe
  wsweesenenewnwwnwsenewsenwwsesesenwne
  neeswseenwwswnwswswnw
  nenwswwsewswnenenewsenwsenwnesesenew
  enewnwewneswsewnwswenweswnenwsenwsw
  sweneswneswneneenwnewenewwneswswnese
  swwesenesewenwneswnwwneseswwne
  enesenwswwswneneswsenwnewswseenwsese
  wnwnesenesenenwwnenwsewesewsesesew
  nenewswnwewswnenesenwnesewesw
  eneswnwswnwsenenwnwnwwseeswneewsenese
  neswnwewnwnwseenwseesewsenwsweewe
  wseweeenwnesenwwwswnew
  """

  @input "24_lobby_layout.txt" |> Path.expand("input_files") |> File.read!()

  describe "1" do
    test "unit test" do
      assert LobbyLayout.part_1(@unit_test_input) == 10
    end

    test "puzzle answer" do
      assert LobbyLayout.part_1(@input) == 549
    end
  end

  describe "2" do
    test "unit test" do
      assert LobbyLayout.part_2(@unit_test_input) == 2208
    end

    test "puzzle answer" do
      assert LobbyLayout.part_2(@input) == 4147
    end
  end
end
