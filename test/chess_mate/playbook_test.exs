defmodule ChessMate.PlaybookTest do
  use ChessMate.DataCase

  alias ChessMate.Playbook

  describe "team_round" do
    alias ChessMate.Playbook.TeamRound

    import ChessMate.PlaybookFixtures

    @invalid_attrs %{comments: nil, lineup: nil}

    test "list_team_round/0 returns all team_round" do
      team_round = team_round_fixture()
      assert Playbook.list_team_round() == [team_round]
    end

    test "get_team_round!/1 returns the team_round with given id" do
      team_round = team_round_fixture()
      assert Playbook.get_team_round!(team_round.id) == team_round
    end

    test "create_team_round/1 with valid data creates a team_round" do
      valid_attrs = %{comments: "some comments", lineup: [1, 2]}

      assert {:ok, %TeamRound{} = team_round} = Playbook.create_team_round(valid_attrs)
      assert team_round.comments == "some comments"
      assert team_round.lineup == [1, 2]
    end

    test "create_team_round/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Playbook.create_team_round(@invalid_attrs)
    end

    test "update_team_round/2 with valid data updates the team_round" do
      team_round = team_round_fixture()
      update_attrs = %{comments: "some updated comments", lineup: [1]}

      assert {:ok, %TeamRound{} = team_round} = Playbook.update_team_round(team_round, update_attrs)
      assert team_round.comments == "some updated comments"
      assert team_round.lineup == [1]
    end

    test "update_team_round/2 with invalid data returns error changeset" do
      team_round = team_round_fixture()
      assert {:error, %Ecto.Changeset{}} = Playbook.update_team_round(team_round, @invalid_attrs)
      assert team_round == Playbook.get_team_round!(team_round.id)
    end

    test "delete_team_round/1 deletes the team_round" do
      team_round = team_round_fixture()
      assert {:ok, %TeamRound{}} = Playbook.delete_team_round(team_round)
      assert_raise Ecto.NoResultsError, fn -> Playbook.get_team_round!(team_round.id) end
    end

    test "change_team_round/1 returns a team_round changeset" do
      team_round = team_round_fixture()
      assert %Ecto.Changeset{} = Playbook.change_team_round(team_round)
    end
  end

  describe "player_availability" do
    alias ChessMate.Playbook.PlayerAvailability

    import ChessMate.PlaybookFixtures

    @invalid_attrs %{status: nil}

    test "list_player_availability/0 returns all player_availability" do
      player_availability = player_availability_fixture()
      assert Playbook.list_player_availability() == [player_availability]
    end

    test "get_player_availability!/1 returns the player_availability with given id" do
      player_availability = player_availability_fixture()
      assert Playbook.get_player_availability!(player_availability.id) == player_availability
    end

    test "create_player_availability/1 with valid data creates a player_availability" do
      valid_attrs = %{status: "some status"}

      assert {:ok, %PlayerAvailability{} = player_availability} = Playbook.create_player_availability(valid_attrs)
      assert player_availability.status == "some status"
    end

    test "create_player_availability/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Playbook.create_player_availability(@invalid_attrs)
    end

    test "update_player_availability/2 with valid data updates the player_availability" do
      player_availability = player_availability_fixture()
      update_attrs = %{status: "some updated status"}

      assert {:ok, %PlayerAvailability{} = player_availability} = Playbook.update_player_availability(player_availability, update_attrs)
      assert player_availability.status == "some updated status"
    end

    test "update_player_availability/2 with invalid data returns error changeset" do
      player_availability = player_availability_fixture()
      assert {:error, %Ecto.Changeset{}} = Playbook.update_player_availability(player_availability, @invalid_attrs)
      assert player_availability == Playbook.get_player_availability!(player_availability.id)
    end

    test "delete_player_availability/1 deletes the player_availability" do
      player_availability = player_availability_fixture()
      assert {:ok, %PlayerAvailability{}} = Playbook.delete_player_availability(player_availability)
      assert_raise Ecto.NoResultsError, fn -> Playbook.get_player_availability!(player_availability.id) end
    end

    test "change_player_availability/1 returns a player_availability changeset" do
      player_availability = player_availability_fixture()
      assert %Ecto.Changeset{} = Playbook.change_player_availability(player_availability)
    end
  end
end
