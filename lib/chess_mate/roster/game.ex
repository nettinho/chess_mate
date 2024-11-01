defmodule ChessMate.Roster.Game do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChessMate.Roster.PlayerTeam
  alias ChessMate.Roster.Round

  @valid_results ["local", "visitor", "draw"]

  schema "games" do
    field :result, :string
    field :team_table, :integer
    field :table, :integer

    belongs_to :round, Round
    belongs_to :local, PlayerTeam
    belongs_to :visitor, PlayerTeam

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:round_id, :team_table, :table, :result, :local_id, :visitor_id])
    |> validate_inclusion(:result, @valid_results)
    |> validate_required([:round_id, :team_table, :table])
  end
end
