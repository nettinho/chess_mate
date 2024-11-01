defmodule ChessMate.PlaybookFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChessMate.Playbook` context.
  """

  @doc """
  Generate a team_round.
  """
  def team_round_fixture(attrs \\ %{}) do
    {:ok, team_round} =
      attrs
      |> Enum.into(%{
        comments: "some comments",
        lineup: [1, 2]
      })
      |> ChessMate.Playbook.create_team_round()

    team_round
  end

  @doc """
  Generate a player_availability.
  """
  def player_availability_fixture(attrs \\ %{}) do
    {:ok, player_availability} =
      attrs
      |> Enum.into(%{
        status: "some status"
      })
      |> ChessMate.Playbook.create_player_availability()

    player_availability
  end
end
