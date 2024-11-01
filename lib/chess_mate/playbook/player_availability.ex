defmodule ChessMate.Playbook.PlayerAvailability do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChessMate.Playbook.TeamRound
  alias ChessMate.Roster.PlayerTeam

  schema "player_availabilities" do
    field :status, :string, default: "pending"

    belongs_to :team_round, TeamRound
    belongs_to :team_player, PlayerTeam, foreign_key: :team_player_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player_availability, attrs) do
    player_availability
    |> cast(attrs, [:status, :team_round_id, :team_player_id])
    |> validate_required([:status, :team_round_id, :team_player_id])
  end
end
