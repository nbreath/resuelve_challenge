defmodule Resuelve.TeamTest do
  use ExUnit.Case
  alias Resuelve.Team

  @players [
    %{
      "nombre" => "Luis",
      "nivel" => "Cuauh",
      "goles" => 19,
      "sueldo" => 50000,
      "bono" => 10000,
      "sueldo_completo" => nil,
      "equipo" => "rojo"
    },
    %{
      "nombre" => "Juan",
      "nivel" => "A",
      "goles" => 6,
      "sueldo" => 50000,
      "bono" => 10000,
      "sueldo_completo" => nil,
      "equipo" => "rojo"
    },
    %{
      "nombre" => "Pedro",
      "nivel" => "B",
      "goles" => 7,
      "sueldo" => 50000,
      "bono" => 10000,
      "sueldo_completo" => nil,
      "equipo" => "rojo"
    },
    %{
      "nombre" => "Martín",
      "nivel" => "C",
      "goles" => 16,
      "sueldo" => 50000,
      "bono" => 10000,
      "sueldo_completo" => nil,
      "equipo" => "rojo"
    }
  ]

  @players_salaries [
    %{
      "bono" => 10000,
      "equipo" => "rojo",
      "goles" => 19,
      "goles_minimos" => 20,
      "nombre" => "Luis",
      "sueldo" => 50000,
      "sueldo_completo" => 59550.0
    },
    %{
      "bono" => 10000,
      "equipo" => "rojo",
      "goles" => 6,
      "goles_minimos" => 5,
      "nombre" => "Juan",
      "sueldo" => 50000,
      "sueldo_completo" => 59800
    },
    %{
      "bono" => 10000,
      "equipo" => "rojo",
      "goles" => 7,
      "goles_minimos" => 10,
      "nombre" => "Pedro",
      "sueldo" => 50000,
      "sueldo_completo" => 58300
    },
    %{
      "bono" => 10000,
      "equipo" => "rojo",
      "goles" => 16,
      "goles_minimos" => 15,
      "nombre" => "Martín",
      "sueldo" => 50000,
      "sueldo_completo" => 59800
    }
  ]

  test "calculate_score_percentage/2 returns 1 if individual score is equal or greater than level score" do
    assert Team.calculate_score_percentage(10, 5) == 1
    assert Team.calculate_score_percentage(5, 5) == 1
  end

  test "calculate_score_percentage/2 returns number less than 1 if individual score is less than level score" do
    assert Team.calculate_score_percentage(5, 10) == 0.5
    assert Team.calculate_score_percentage(5, 15) == 1 / 3
  end

  test "calculate_team_score_percentage/1 returns number less than 1 if team score is less than the team level score" do
    assert Team.calculate_team_score_percentage(@players) == 48 / 50
  end

  test "calculate_team_score_percentage/1 returns 1 if individual score is equal or greater than the team level score" do
    assert Team.calculate_team_score_percentage([
             %{
               "bono" => 10000,
               "equipo" => "rojo",
               "goles" => 19,
               "nivel" => "Cuauh",
               "nombre" => "Luis",
               "sueldo" => 50000,
               "sueldo_completo" => nil
             },
             %{
               "bono" => 10000,
               "equipo" => "rojo",
               "goles" => 16,
               "nivel" => "A",
               "nombre" => "Juan",
               "sueldo" => 50000,
               "sueldo_completo" => nil
             },
             %{
               "bono" => 10000,
               "equipo" => "rojo",
               "goles" => 7,
               "nivel" => "B",
               "nombre" => "Pedro",
               "sueldo" => 50000,
               "sueldo_completo" => nil
             }
           ]) == 1
  end

  test "calculate_team_full_salaries/1 returns number less than 1 if team score is less than the team level score" do
    assert Team.calculate_team_full_salaries(@players) == @players_salaries
  end

  test "process_team_salaries/1 returns string with the encoded JSON for the team with salaries" do
    assert Team.process_team_salaries(
             "[{\"nombre\":\"Luis\",\"nivel\":\"Cuauh\",\"goles\":19,\"sueldo\":50000,\"bono\":10000,\"sueldo_completo\":null,\"equipo\":\"rojo\"},{\"nombre\":\"Juan\",\"nivel\":\"A\",\"goles\":6,\"sueldo\":50000,\"bono\":10000,\"sueldo_completo\":null,\"equipo\":\"rojo\"},{\"nombre\":\"Pedro\",\"nivel\":\"B\",\"goles\":7,\"sueldo\":50000,\"bono\":10000,\"sueldo_completo\":null,\"equipo\":\"rojo\"},{\"nombre\":\"Mart\u00EDn\",\"nivel\":\"C\",\"goles\":16,\"sueldo\":50000,\"bono\":10000,\"sueldo_completo\":null,\"equipo\":\"rojo\"}]"
           ) ==
             {:ok, @players_salaries}
  end
end
