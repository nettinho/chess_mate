defmodule ChessMate.Repo.Migrations.CreatePlayersTeams do
  use Ecto.Migration

  def change do
    create table(:players_teams) do
      add :board_number, :integer
      add :elo, :integer
      add :title, :string
      add :code, :string
      add :player_id, references(:players, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:players_teams, [:player_id])
    create index(:players_teams, [:team_id])
  end
end
