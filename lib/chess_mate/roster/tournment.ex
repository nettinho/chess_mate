defmodule ChessMate.Roster.Tournment do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChessMate.Roster.Team
  alias ChessMate.Roster.Round

  schema "tournments" do
    field :code, :string
    field :name, :string
    field :when, :string
    field :rate, :string

    has_many :teams, Team
    has_many :rounds, Round

    has_one :next_round, Round

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tournment, attrs) do
    tournment
    |> cast(attrs, [:code, :name, :when, :rate])
    |> validate_required([:code, :name])
  end
end
