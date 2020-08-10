defmodule ResuelveWeb.PageLive do
  use ResuelveWeb, :live_view
  alias Resuelve.Team

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, players_with_salaries: "")}
  end

  @impl true
  def handle_event("suggest", %{"players-data" => players_data}, socket) do
    socket =
      case Team.process_team_salaries(players_data) do
        {:ok, players_with_salaries} ->
          assign(socket,
            players_with_salaries: Poison.encode!(players_with_salaries, pretty: true)
          )

        {:error, _} ->
          assign(socket, players_with_salaries: "Invalid data")
      end

    {:noreply, socket}
  end
end
