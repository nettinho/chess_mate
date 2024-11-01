defmodule ChessMate.Roster.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChessMate.Roster.Tournment
  alias ChessMate.Roster.PlayerTeam
  alias ChessMate.Playbook.TeamRound

  schema "teams" do
    field :code, :string
    field :name, :string

    belongs_to :tournment, Tournment
    has_many :players, PlayerTeam

    has_many :rounds, TeamRound
    has_one :next_round, TeamRound

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:code, :name, :tournment_id])
    |> validate_required([:code, :name, :tournment_id])
  end
end
