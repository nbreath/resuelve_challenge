defmodule Resuelve.Team do
  @team_level_scores %{"A" => 5, "B" => 10, "C" => 15, "Cuauh" => 20}

  def calculate_score_percentage(individual_score, level_score)
      when individual_score > level_score,
      do: 1

  def calculate_score_percentage(individual_score, level_score) do
    calculate_percentage(individual_score, level_score)
  end

  def calculate_team_score_percentage(players) do
    {team_score, team_level_score} =
      Enum.reduce(players, {0, 0}, fn %{"goles" => score, "nivel" => level},
                                      {player_score_acc, level_score_acc} ->
        {player_score_acc + score, level_score_acc + @team_level_scores[level]}
      end)

    calculate_score_percentage(team_score, team_level_score)
  end

  def calculate_team_full_salaries(players) do
    team_score_percentage = calculate_team_score_percentage(players)

    Enum.map(players, fn %{
                           "goles" => score,
                           "nivel" => level,
                           "sueldo" => salary,
                           "bono" => bonus
                         } = player ->
      individual_score = calculate_score_percentage(score, @team_level_scores[level])
      total_player_percentage = (individual_score + team_score_percentage) / 2
      full_salary = salary + total_player_percentage * bonus

      player
      |> Map.delete("nivel")
      |> Map.merge(%{
        "goles_minimos" => @team_level_scores[level],
        "sueldo_completo" => round(full_salary)
      })
    end)
  end

  def process_team_salaries(players_binary) do
    with {:ok, parsed_data} when is_list(parsed_data) and length(parsed_data) > 0 <-
           Poison.decode(players_binary) do
      players_salaries = calculate_team_full_salaries(parsed_data)

      {:ok, players_salaries}
    else
      {:ok, _} ->
        {:error, "Not supported structure"}

      {:error, error} ->
        {:error, error}

      {:error, error, _} ->
        {:error, error}
    end
  end

  defp calculate_percentage(number, total), do: number / total
end
