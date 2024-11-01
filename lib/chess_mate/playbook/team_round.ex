defmodule ChessMate.Playbook.TeamRound do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChessMate.Roster.Round
  alias ChessMate.Roster.Team
  alias ChessMate.Playbook.PlayerAvailability

  schema "team_rounds" do
    field :comments, :string
    field :lineup, {:array, :integer}, default: []

    belongs_to :round, Round
    belongs_to :team, Team

    has_many :players, PlayerAvailability

    field :opponent_team, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team_round, attrs) do
    team_round
    |> cast(attrs, [:comments, :lineup, :round_id, :team_id])
    |> validate_required([:round_id, :team_id])
  end
end
