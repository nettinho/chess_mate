defmodule ChessMate.Roster.PlayerTeam do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChessMate.Roster.Player
  alias ChessMate.Roster.Team
  alias ChessMate.Roster.Game

  schema "players_teams" do
    field :board_number, :integer
    field :elo, :integer
    field :title, :string
    field :code, :string

    belongs_to :player, Player
    belongs_to :team, Team

    has_many :games_as_local, Game, foreign_key: :local_id
    has_many :games_as_visitor, Game, foreign_key: :visitor_id
    # has_many :games, Game

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player_team, attrs) do
    player_team
    |> cast(attrs, [:player_id, :team_id, :code, :elo, :title, :board_number])
    |> validate_required([:player_id, :team_id, :code, :board_number])
  end
end
