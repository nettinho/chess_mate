defmodule ChessMate.Roster.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChessMate.Roster.Tournment
  alias ChessMate.Roster.PlayerTeam
  alias ChessMate.Playbook.TeamRound

  @derive {
    Flop.Schema,
    filterable: [:searchable],
    sortable: [
      :name,
      :initial_rank,
      :current_rank,
      :points,
      :average_elo
    ],
    default_order: %{
      order_by: [:current_rank],
      order_directions: [:asc]
    },
    adapter_opts: [
      compound_fields: [
        searchable: [:name]
      ]
    ]
  }

  schema "teams" do
    field :code, :string
    field :name, :string

    field :initial_rank, :integer
    field :current_rank, :integer
    field :points, :float
    field :average_elo, :integer

    belongs_to :tournment, Tournment
    has_many :players, PlayerTeam

    has_many :rounds, TeamRound
    has_one :next_round, TeamRound

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [
      :code,
      :name,
      :tournment_id,
      :initial_rank,
      :current_rank,
      :points,
      :average_elo
    ])
    |> validate_required([:code, :name, :tournment_id])
  end
end
