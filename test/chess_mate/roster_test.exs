defmodule ChessMate.RosterTest do
  use ChessMate.DataCase

  alias ChessMate.Roster

  describe "players" do
    alias ChessMate.Roster.Player

    import ChessMate.RosterFixtures

    @invalid_attrs %{name: nil, fide: nil}

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Roster.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Roster.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      valid_attrs = %{name: "some name", fide: "some fide"}

      assert {:ok, %Player{} = player} = Roster.create_player(valid_attrs)
      assert player.name == "some name"
      assert player.fide == "some fide"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Roster.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      update_attrs = %{name: "some updated name", fide: "some updated fide"}

      assert {:ok, %Player{} = player} = Roster.update_player(player, update_attrs)
      assert player.name == "some updated name"
      assert player.fide == "some updated fide"
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Roster.update_player(player, @invalid_attrs)
      assert player == Roster.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Roster.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Roster.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Roster.change_player(player)
    end
  end

  describe "tournments" do
    alias ChessMate.Roster.Tournment

    import ChessMate.RosterFixtures

    @invalid_attrs %{name: nil}

    test "list_tournments/0 returns all tournments" do
      tournment = tournment_fixture()
      assert Roster.list_tournments() == [tournment]
    end

    test "get_tournment!/1 returns the tournment with given id" do
      tournment = tournment_fixture()
      assert Roster.get_tournment!(tournment.id) == tournment
    end

    test "create_tournment/1 with valid data creates a tournment" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Tournment{} = tournment} = Roster.create_tournment(valid_attrs)
      assert tournment.name == "some name"
    end

    test "create_tournment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Roster.create_tournment(@invalid_attrs)
    end

    test "update_tournment/2 with valid data updates the tournment" do
      tournment = tournment_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Tournment{} = tournment} = Roster.update_tournment(tournment, update_attrs)
      assert tournment.name == "some updated name"
    end

    test "update_tournment/2 with invalid data returns error changeset" do
      tournment = tournment_fixture()
      assert {:error, %Ecto.Changeset{}} = Roster.update_tournment(tournment, @invalid_attrs)
      assert tournment == Roster.get_tournment!(tournment.id)
    end

    test "delete_tournment/1 deletes the tournment" do
      tournment = tournment_fixture()
      assert {:ok, %Tournment{}} = Roster.delete_tournment(tournment)
      assert_raise Ecto.NoResultsError, fn -> Roster.get_tournment!(tournment.id) end
    end

    test "change_tournment/1 returns a tournment changeset" do
      tournment = tournment_fixture()
      assert %Ecto.Changeset{} = Roster.change_tournment(tournment)
    end
  end

  describe "teams" do
    alias ChessMate.Roster.Team

    import ChessMate.RosterFixtures

    @invalid_attrs %{name: nil}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Roster.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Roster.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Team{} = team} = Roster.create_team(valid_attrs)
      assert team.name == "some name"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Roster.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Team{} = team} = Roster.update_team(team, update_attrs)
      assert team.name == "some updated name"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Roster.update_team(team, @invalid_attrs)
      assert team == Roster.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Roster.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Roster.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Roster.change_team(team)
    end
  end

  describe "players_teams" do
    alias ChessMate.Roster.PlayerTeam

    import ChessMate.RosterFixtures

    @invalid_attrs %{board_number: nil}

    test "list_players_teams/0 returns all players_teams" do
      player_team = player_team_fixture()
      assert Roster.list_players_teams() == [player_team]
    end

    test "get_player_team!/1 returns the player_team with given id" do
      player_team = player_team_fixture()
      assert Roster.get_player_team!(player_team.id) == player_team
    end

    test "create_player_team/1 with valid data creates a player_team" do
      valid_attrs = %{board_number: 42}

      assert {:ok, %PlayerTeam{} = player_team} = Roster.create_player_team(valid_attrs)
      assert player_team.board_number == 42
    end

    test "create_player_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Roster.create_player_team(@invalid_attrs)
    end

    test "update_player_team/2 with valid data updates the player_team" do
      player_team = player_team_fixture()
      update_attrs = %{board_number: 43}

      assert {:ok, %PlayerTeam{} = player_team} = Roster.update_player_team(player_team, update_attrs)
      assert player_team.board_number == 43
    end

    test "update_player_team/2 with invalid data returns error changeset" do
      player_team = player_team_fixture()
      assert {:error, %Ecto.Changeset{}} = Roster.update_player_team(player_team, @invalid_attrs)
      assert player_team == Roster.get_player_team!(player_team.id)
    end

    test "delete_player_team/1 deletes the player_team" do
      player_team = player_team_fixture()
      assert {:ok, %PlayerTeam{}} = Roster.delete_player_team(player_team)
      assert_raise Ecto.NoResultsError, fn -> Roster.get_player_team!(player_team.id) end
    end

    test "change_player_team/1 returns a player_team changeset" do
      player_team = player_team_fixture()
      assert %Ecto.Changeset{} = Roster.change_player_team(player_team)
    end
  end

  describe "rounds" do
    alias ChessMate.Roster.Round

    import ChessMate.RosterFixtures

    @invalid_attrs %{timestamp: nil, round: nil}

    test "list_rounds/0 returns all rounds" do
      round = round_fixture()
      assert Roster.list_rounds() == [round]
    end

    test "get_round!/1 returns the round with given id" do
      round = round_fixture()
      assert Roster.get_round!(round.id) == round
    end

    test "create_round/1 with valid data creates a round" do
      valid_attrs = %{timestamp: ~U[2024-10-30 08:55:00Z], round: 42}

      assert {:ok, %Round{} = round} = Roster.create_round(valid_attrs)
      assert round.timestamp == ~U[2024-10-30 08:55:00Z]
      assert round.round == 42
    end

    test "create_round/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Roster.create_round(@invalid_attrs)
    end

    test "update_round/2 with valid data updates the round" do
      round = round_fixture()
      update_attrs = %{timestamp: ~U[2024-10-31 08:55:00Z], round: 43}

      assert {:ok, %Round{} = round} = Roster.update_round(round, update_attrs)
      assert round.timestamp == ~U[2024-10-31 08:55:00Z]
      assert round.round == 43
    end

    test "update_round/2 with invalid data returns error changeset" do
      round = round_fixture()
      assert {:error, %Ecto.Changeset{}} = Roster.update_round(round, @invalid_attrs)
      assert round == Roster.get_round!(round.id)
    end

    test "delete_round/1 deletes the round" do
      round = round_fixture()
      assert {:ok, %Round{}} = Roster.delete_round(round)
      assert_raise Ecto.NoResultsError, fn -> Roster.get_round!(round.id) end
    end

    test "change_round/1 returns a round changeset" do
      round = round_fixture()
      assert %Ecto.Changeset{} = Roster.change_round(round)
    end
  end

  describe "games" do
    alias ChessMate.Roster.Game

    import ChessMate.RosterFixtures

    @invalid_attrs %{result: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Roster.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Roster.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{result: "some result"}

      assert {:ok, %Game{} = game} = Roster.create_game(valid_attrs)
      assert game.result == "some result"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Roster.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{result: "some updated result"}

      assert {:ok, %Game{} = game} = Roster.update_game(game, update_attrs)
      assert game.result == "some updated result"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Roster.update_game(game, @invalid_attrs)
      assert game == Roster.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Roster.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Roster.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Roster.change_game(game)
    end
  end
end
