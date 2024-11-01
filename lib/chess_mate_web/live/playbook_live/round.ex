defmodule ChessMateWeb.PlaybookLive.Round do
  use ChessMateWeb, :live_view

  alias ChessMate.Playbook

  def mount(_params, _session, socket) do
    {:ok, assign(socket, team_round: nil)}
  end

  def handle_params(%{"team_id" => team_id, "round_id" => round_id}, _, socket) do
    {:ok, team_round} =
      Playbook.put_team_round(%{round_id: round_id, team_id: team_id},
        preload: [:round, team: [players: [:player]]]
      )

    team_round.team.players
    |> Enum.sort_by(& &1.board_number)
    |> Enum.each(fn %{id: team_player_id} ->
      {:ok, player} =
        Playbook.put_player_availability(%{
          team_player_id: team_player_id,
          team_round_id: team_round.id
        })

      player
    end)

    {:noreply,
     socket
     |> assign(team_round: team_round)
     |> assign_players()}
  end

  def handle_event("change_availability", %{"id" => id, "status" => status}, socket) do
    id
    |> Playbook.get_player_availability!()
    |> Playbook.update_player_availability(%{status: status})

    {:noreply, assign_players(socket)}
  end

  def handle_event("toggle_lineup", %{"id" => player_id}, socket) do
    %{team_round: %{id: id}} = socket.assigns

    team_round = %{lineup: lineup} = Playbook.get_team_round!(id)

    lineup =
      if player_id in lineup do
        Enum.reject(lineup, fn item -> item == player_id end)
      else
        [player_id | lineup]
      end

    {:ok, team_round} =
      Playbook.update_team_round(team_round, %{lineup: lineup},
        preload: [:round, team: [players: [:player]]]
      )

    {:noreply,
     assign(socket,
       team_round: team_round,
       lineup_count: Enum.count(lineup)
     )}
  end

  defp assign_players(socket) do
    %{team_round: %{id: id}} = socket.assigns

    %{players: players, lineup: lineup} =
      Playbook.get_team_round!(id, preload: [players: [team_player: [:player]]])

    players = Enum.sort_by(players, & &1.team_player.board_number)

    {available_count, unavailable_count, unknown_count, pending_count} =
      Enum.reduce(players, {0, 0, 0, 0}, fn
        %{status: "pending"},
        {available_count, unavailable_count, unknown_count, pending_count} ->
          {available_count, unavailable_count, unknown_count, pending_count + 1}

        %{status: "unknown"},
        {available_count, unavailable_count, unknown_count, pending_count} ->
          {available_count, unavailable_count, unknown_count + 1, pending_count}

        %{status: "unavailable"},
        {available_count, unavailable_count, unknown_count, pending_count} ->
          {available_count, unavailable_count + 1, unknown_count, pending_count}

        %{status: "available"},
        {available_count, unavailable_count, unknown_count, pending_count} ->
          {available_count + 1, unavailable_count, unknown_count, pending_count}
      end)

    assign(socket,
      players: players,
      total_count: Enum.count(players),
      available_count: available_count,
      unavailable_count: unavailable_count,
      unknown_count: unknown_count,
      pending_count: pending_count,
      lineup_count: Enum.count(lineup)
    )
  end
end
