defmodule ChessMateWeb.TeamsLive.Show do
  use ChessMateWeb, :live_view

  alias ChessMate.Roster

  def mount(_params, _session, socket) do
    {:ok, assign(socket, team: nil)}
  end

  def handle_params(%{"id" => id}, _, socket) do
    team =
      Roster.get_team!(id,
        preload: [
          players: [
            :player,
            games_as_local: [:round, visitor: [:player, :team], local: [:player]],
            games_as_visitor: [:round, visitor: [:player], local: [:player, :team]]
          ],
          tournment: [:rounds]
        ]
      )

    games_as_local =
      team.players
      |> Enum.flat_map(& &1.games_as_local)
      |> Enum.map(&Roster.parse_game_as_local/1)

    games_as_visitor =
      team.players
      |> Enum.flat_map(& &1.games_as_visitor)
      |> Enum.map(&Roster.parse_game_as_visitor/1)

    games =
      (games_as_local ++ games_as_visitor)
      |> Enum.group_by(& &1.round)
      |> Enum.sort_by(fn {%{round: round}, _} -> round end)
      |> Enum.map(fn {round, games} ->
        {opponent_id, opponent_name} =
          games
          |> Enum.sort_by(& &1.table)
          |> List.first()
          |> case do
            %{opponent_team: {opponent_id, opponent_name}} -> {opponent_id, opponent_name}
            _ -> {nil, nil}
          end

        {opponent_points, team_points} =
          games
          |> Enum.reject(&is_nil(&1.win))
          |> Enum.reduce({0, 0}, fn
            %{win: "draw"}, {opponent_points, team_points} ->
              {opponent_points + 0.5, team_points + 0.5}

            %{win: "win"}, {opponent_points, team_points} ->
              {opponent_points, team_points + 1}

            %{win: "lose"}, {opponent_points, team_points} ->
              {opponent_points + 1, team_points}
          end)

        games =
          games
          |> Enum.sort_by(& &1.table)
          |> Enum.reject(&is_nil(&1.win))

        round_win = fn
          0, 0 -> nil
          p, p -> "draw"
          p1, p2 when p1 > p2 -> "win"
          p1, p2 when p1 < p2 -> "lose"
          _, _ -> nil
        end

        {%{
           id: round.id,
           round: round.round,
           timestamp: round.timestamp,
           opponent_name: opponent_name,
           opponent_id: opponent_id,
           opponent_points: opponent_points,
           team_points: team_points,
           round_win: round_win.(team_points, opponent_points)
         }, games}
      end)

    {victory, loss, draw} =
      Enum.reduce(games, {0, 0, 0}, fn
        {%{round_win: "win"}, _}, {victory, loss, draw} -> {victory + 1, loss, draw}
        {%{round_win: "lose"}, _}, {victory, loss, draw} -> {victory, loss + 1, draw}
        {%{round_win: "draw"}, _}, {victory, loss, draw} -> {victory, loss, draw + 1}
        _, {victory, loss, draw} -> {victory, loss, draw}
      end)

    players = Enum.sort_by(team.players, & &1.board_number)

    rounds = Enum.sort_by(team.tournment.rounds, & &1.round)

    current_year = Date.utc_today().year

    players_with_age =
      Enum.reject(players, &(is_nil(&1.player.birth_year) or &1.player.birth_year == 0))

    age_sum =
      players_with_age
      |> Enum.map(&(current_year - &1.player.birth_year))
      |> Enum.sum()

    {:noreply,
     assign(socket,
       team: team,
       rounds: rounds,
       players: players,
       games: games,
       victory: victory,
       loss: loss,
       draw: draw,
       current_year: current_year,
       player_count: Enum.count(players),
       average_age: round(age_sum / Enum.count(players_with_age))
     )}
  end

  defp rank_icon(%{team: %{initial_rank: initial, current_rank: current}} = assigns)
       when initial > current,
       do: ~H"""
       <.icon name="hero-arrow-up" class="text-green-500 dark:text-green-700 w-4 h-4 mr-1" />
       """

  defp rank_icon(%{team: %{initial_rank: initial, current_rank: current}} = assigns)
       when initial < current,
       do: ~H"""
       <.icon name="hero-arrow-down" class="text-red-500 dark:text-red-700 w-4 h-4 mr-1" />
       """

  defp rank_icon(assigns),
    do: ~H"""
    <.icon name="hero-minus" class="text-yellow-500 dark:text-yellow-700 w-4 h-4 mr-1" />
    """
end
