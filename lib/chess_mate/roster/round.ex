defmodule ChessMate.Roster.Round do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChessMate.Roster.Tournment
  alias ChessMate.Roster.Game

  schema "rounds" do
    field :timestamp, :utc_datetime
    field :round, :integer

    belongs_to :tournment, Tournment
    has_many :games, Game

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(round, attrs) do
    round
    |> cast(attrs, [:round, :timestamp, :tournment_id])
    |> validate_required([:round, :timestamp, :tournment_id])
  end
end
