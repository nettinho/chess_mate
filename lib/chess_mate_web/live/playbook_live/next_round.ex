defmodule ChessMateWeb.PlaybookLive.NextRound do
  use ChessMateWeb, :live_view

  alias ChessMate.Playbook
  alias ChessMate.Roster

  def mount(_params, _session, socket) do
    prefixes =
      socket.assigns.current_user
      |> Map.get(:roles)
      |> Enum.map(& &1.team_prefix)

    tournments =
      prefixes
      |> Roster.get_next_round_tournments()
      |> Playbook.put_tornments_team_rounds()

    {:ok,
     assign(socket,
       tournments: tournments,
       prefixes: prefixes,
       expanded: ""
     )}
  end

  def handle_event("expand", %{"team_id" => id}, socket) do
    %{expanded: expanded} = socket.assigns
    {:noreply, assign(socket, expanded: (expanded == id && "") || id)}
  end

  def handle_event("change_availability", %{"id" => id, "status" => status}, socket) do
    id
    |> Playbook.get_player_availability!()
    |> Playbook.update_player_availability(%{status: status})

    {:noreply, refesh_data(socket)}
  end

  def handle_event("toggle_lineup", %{"id" => player_id, "team_round_id" => id}, socket) do
    team_round = %{lineup: lineup} = Playbook.get_team_round!(id)

    lineup =
      if player_id in lineup do
        Enum.reject(lineup, fn item -> item == player_id end)
      else
        [player_id | lineup]
      end

    {:ok, _team_round} =
      Playbook.update_team_round(team_round, %{lineup: lineup},
        preload: [:round, team: [players: [:player]]]
      )

    {:noreply, refesh_data(socket)}
  end

  defp refesh_data(socket) do
    %{prefixes: prefixes} = socket.assigns

    tournments = Roster.get_next_round_tournments_with_round(prefixes)

    assign(socket, tournments: tournments)
  end
end
