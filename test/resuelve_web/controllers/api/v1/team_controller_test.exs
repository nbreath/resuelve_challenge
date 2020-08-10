defmodule ResuelveWeb.TeamControllerTest do
  use ResuelveWeb.ConnCase, asyn: true

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

  describe "process list of players into players with salaries" do
    test "renders list of players with salaries when data is valid", %{conn: conn} do
      upload = %Plug.Upload{path: "test/fixtures/players.json", filename: "players.json"}

      conn = post(conn, Routes.api_v1_team_path(conn, :create), players: upload)

      assert @players_salaries == json_response(conn, 200)["data"]
    end

    test "renders empty list when file data is invalid", %{conn: conn} do
      upload = %Plug.Upload{path: "test/fixtures/no_players.json", filename: "players.json"}

      conn = post(conn, Routes.api_v1_team_path(conn, :create), players: upload)

      assert [] == json_response(conn, 200)["data"]
    end
  end
end
