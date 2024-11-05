defmodule ChessMate.Roster.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :name, :string
    field :fide, :string
    field :country, :string
    field :gender, :string
    field :birth_year, :integer

    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:fide, :name, :country, :gender, :birth_year])
    |> validate_required([:fide, :name])
  end
end
