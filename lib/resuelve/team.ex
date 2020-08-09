defmodule Resuelve.Team do
  @level_score %{"A" => 5, "B" => 10, "C" => 15, "Cuauh" => 20}

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
        {player_score_acc + score, level_score_acc + @level_score[level]}
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
      individual_score = calculate_score_percentage(score, @level_score[level])
      total_player_percentage = (individual_score + team_score_percentage) / 2
      full_salary = salary + total_player_percentage * bonus

      player
      |> Map.delete("nivel")
      |> Map.merge(%{
        "goles_minimos" => @level_score[level],
        "sueldo_completo" => round(full_salary)
      })
    end)
  end

  def process_team_salaries(players_binary) do
    case Poison.decode(players_binary) do
      {:ok, parsed_data} ->
        players_salaries =
          parsed_data
          |> calculate_team_full_salaries()
          |> Poison.encode!(pretty: true)

        {:ok, players_salaries}

      {:error, error} ->
        {:error, error}
    end
  end

  defp calculate_percentage(number, total), do: number / total
end
