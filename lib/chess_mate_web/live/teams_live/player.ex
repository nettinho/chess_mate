defmodule ChessMateWeb.TeamsLive.Player do
  use ChessMateWeb, :live_view

  alias ChessMate.Roster

  def mount(_params, _session, socket) do
    {:ok, assign(socket, player: nil)}
  end

  def handle_params(%{"id" => id}, _, socket) do
    player =
      Roster.get_player_team!(id,
        preload: [
          :player,
          games_as_local: [:round, visitor: [:player, :team], local: [:player]],
          games_as_visitor: [:round, visitor: [:player], local: [:player, :team]],
          team: [:tournment]
        ]
      )

    games_as_local = Enum.map(player.games_as_local, &Roster.parse_game_as_local/1)
    games_as_visitor = Enum.map(player.games_as_visitor, &Roster.parse_game_as_visitor/1)

    games =
      (games_as_local ++ games_as_visitor)
      |> Enum.reject(&is_nil(&1.win))
      |> Enum.sort_by(& &1.round.round)

    {:noreply, assign(socket, player: player, games: games)}
  end
end
