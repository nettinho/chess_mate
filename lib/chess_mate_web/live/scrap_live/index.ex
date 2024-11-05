defmodule ChessMateWeb.ScrapLive.Index do
  use ChessMateWeb, :live_view

  alias ChessMate.Scrap
  alias ChessMate.Roster

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       tournment_code: nil,
       step: nil,
       tournment_name: nil,
       team_count: nil
     )}
  end

  def handle_event("scrap", %{"tournment" => tournment}, socket) do
    send(self(), {:fetch_tournment, tournment})

    {:noreply,
     assign(socket,
       tournment_code: tournment,
       step: "Fetching tournment"
     )}
  end

  def handle_info({:fetch_tournment, tournment}, socket) do
    {tournment, teams} = Scrap.fetch_tournment(tournment)
    {:ok, %{id: tournment_id, name: name}} = Roster.put_tournment(tournment)

    send(self(), {:fetch_teams, tournment_id, teams})

    {:noreply,
     assign(socket,
       step: "Inserting teams",
       tournment_name: name,
       tournment_id: tournment_id,
       team_count: Enum.count(teams)
     )}
  end

  def handle_info({:fetch_teams, tournment_id, teams}, socket) do
    %{tournment_code: tournment_code} = socket.assigns
    standings = Scrap.fetch_teams_standings(tournment_code)

    teams =
      Enum.map(
        teams,
        &(&1
          |> Map.put(:tournment_id, tournment_id)
          |> Map.merge(Map.get(standings, &1.code))
          |> Roster.put_team()
          |> elem(1))
      )

    send(self(), {:fetch_players, teams, 0})
    # send(self(), {:fetch_players, [], 0})
    {:noreply, assign(socket, step: "Fetching players")}
  end

  def handle_info({:fetch_players, [], count}, socket) do
    send(self(), :fetch_schedule)
    {:noreply, assign(socket, step: "Done fetching #{count + 1} teams")}
  end

  def handle_info(
        {:fetch_players, [%{id: team_id, name: name, code: code} | rest], count},
        socket
      ) do
    %{team_count: team_count, tournment_code: tournment_code} = socket.assigns

    tournment_code
    |> Scrap.fetch_team(code)
    |> Enum.each(fn %{fide: fide} = player ->
      details = Scrap.fetch_player_details(fide)

      {:ok, %{id: player_id}} =
        player
        |> Map.merge(details)
        |> Roster.put_player()

      player
      |> Map.put(:player_id, player_id)
      |> Map.put(:team_id, team_id)
      |> Roster.put_player_team()
    end)

    send(self(), {:fetch_players, rest, count + 1})
    {:noreply, assign(socket, step: "Fetched #{name} #{count + 1}/#{team_count}")}
  end

  def handle_info(:fetch_schedule, socket) do
    %{tournment_code: tournment_code, tournment_id: tournment_id} = socket.assigns

    rounds =
      tournment_code
      |> Scrap.fetch_schedule()
      |> Enum.map(
        &(&1
          |> Map.put(:tournment_id, tournment_id)
          |> Roster.put_round()
          |> elem(1))
      )

    send(self(), {:fetch_games, rounds})
    {:noreply, assign(socket, step: "Fetching games")}
  end

  def handle_info({:fetch_games, []}, socket) do
    {:noreply, assign(socket, step: "Done fetching games of all rounds")}
  end

  def handle_info(
        {:fetch_games, [%{id: round_id, round: round} | rest]},
        socket
      ) do
    %{tournment_code: tournment_code} = socket.assigns

    tournment_code
    |> Scrap.fetch_games(round)
    |> Enum.each(fn game ->
      local_id = fetch_player(game.local)
      visitor_id = fetch_player(game.visitor)

      Roster.put_game(%{
        team_table: game.team_table,
        table: game.table,
        round_id: round_id,
        local_id: local_id,
        visitor_id: visitor_id,
        result: game.result
      })
    end)

    send(self(), {:fetch_games, rest})
    {:noreply, assign(socket, step: "Fetched round #{round}")}
  end

  defp fetch_player(nil), do: nil

  defp fetch_player({team_code, player_code}) do
    %{id: team_id} = Roster.get_team_by(code: team_code)
    %{id: team_player_id} = Roster.get_player_team_by(team_id: team_id, code: player_code)
    team_player_id
  end
end
