defmodule ResuelveWeb.Api.V1.TeamController do
  use ResuelveWeb, :controller
  alias Resuelve.Team

  def create(conn, %{"players" => players_data}) do
    with {:ok, players} <- File.read(players_data.path),
         {:ok, players_with_salaries} <-
           Team.process_team_salaries(players) do
      render(conn, "create.json", players: players_with_salaries)
    else
      {:error, _} ->
        render(conn, "create.json", players: [])
    end
  end
end
