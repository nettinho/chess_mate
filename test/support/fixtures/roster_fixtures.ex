defmodule ChessMate.RosterFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChessMate.Roster` context.
  """

  @doc """
  Generate a player.
  """
  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        fide: "some fide",
        name: "some name"
      })
      |> ChessMate.Roster.create_player()

    player
  end

  @doc """
  Generate a tournment.
  """
  def tournment_fixture(attrs \\ %{}) do
    {:ok, tournment} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ChessMate.Roster.create_tournment()

    tournment
  end

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ChessMate.Roster.create_team()

    team
  end

  @doc """
  Generate a player_team.
  """
  def player_team_fixture(attrs \\ %{}) do
    {:ok, player_team} =
      attrs
      |> Enum.into(%{
        board_number: 42
      })
      |> ChessMate.Roster.create_player_team()

    player_team
  end

  @doc """
  Generate a round.
  """
  def round_fixture(attrs \\ %{}) do
    {:ok, round} =
      attrs
      |> Enum.into(%{
        round: 42,
        timestamp: ~U[2024-10-30 08:55:00Z]
      })
      |> ChessMate.Roster.create_round()

    round
  end

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        result: "some result"
      })
      |> ChessMate.Roster.create_game()

    game
  end
end
