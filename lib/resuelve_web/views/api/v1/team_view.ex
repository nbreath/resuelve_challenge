defmodule ResuelveWeb.Api.V1.TeamView do
  use ResuelveWeb, :view

  def render("create.json", %{players: players}) do
    %{
      data: render_many(players, __MODULE__, "player.json", as: :player)
    }
  end

  def render("player.json", %{player: player}) do
    %{
      "nombre" => player["nombre"],
      "goles_minimos" => player["goles_minimos"],
      "goles" => player["goles"],
      "sueldo" => player["sueldo"],
      "bono" => player["bono"],
      "sueldo_completo" => player["sueldo_completo"],
      "equipo" => player["equipo"]
    }
  end
end
