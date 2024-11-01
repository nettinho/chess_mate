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

    parse_player = fn
      %{
        player: %{name: name},
        elo: elo,
        title: title
      } ->
        %{name: name, elo: elo, title: title}

      nil ->
        %{name: nil, elo: nil, title: nil}
    end

    player_team = fn
      %{team: %{name: team_name}} -> team_name
      _ -> nil
    end

    result_to_win = fn
      _, "draw" -> "draw"
      win, win -> "win"
      _, nil -> nil
      _, _ -> "lose"
    end

    games_as_local =
      team.players
      |> Enum.flat_map(& &1.games_as_local)
      |> Enum.map(fn
        %{
          table: table,
          round: round,
          result: result,
          local: local,
          visitor: visitor
        } ->
          %{
            table: table,
            round: round,
            team_player: parse_player.(local),
            opponent_player: parse_player.(visitor),
            opponent_team: player_team.(visitor),
            win: result_to_win.("local", result)
          }
      end)

    games_as_visitor =
      team.players
      |> Enum.flat_map(& &1.games_as_visitor)
      |> Enum.map(fn %{
                       table: table,
                       round: round,
                       result: result,
                       local: local,
                       visitor: visitor
                     } ->
        %{
          table: table,
          round: round,
          team_player: parse_player.(visitor),
          opponent_player: parse_player.(local),
          opponent_team: player_team.(local),
          win: result_to_win.("visitor", result)
        }
      end)

    games =
      (games_as_local ++ games_as_visitor)
      |> Enum.group_by(& &1.round)
      |> Enum.sort_by(fn {%{round: round}, _} -> round end)
      |> Enum.map(fn {round, games} ->
        %{opponent_team: opponent_name} = List.first(games)

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
          p, p -> "draw"
          p1, p2 when p1 > p2 -> "win"
          _, _ -> "lose"
        end

        {%{
           id: round.id,
           round: round.round,
           timestamp: round.timestamp,
           opponent_name: opponent_name,
           opponent_points: opponent_points,
           team_points: team_points,
           round_win: round_win.(team_points, opponent_points)
         }, games}
      end)

    players = Enum.sort_by(team.players, & &1.board_number)

    rounds = Enum.sort_by(team.tournment.rounds, & &1.round)

    {:noreply,
     assign(socket,
       team: team,
       rounds: rounds,
       players: players,
       games: games
     )}
  end
end
