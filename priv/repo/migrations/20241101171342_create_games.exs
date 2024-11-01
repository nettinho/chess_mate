defmodule ChessMate.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :result, :string
      add :team_table, :integer
      add :table, :integer
      add :round_id, references(:rounds, on_delete: :nothing)
      add :local_id, references(:players_teams, on_delete: :nothing)
      add :visitor_id, references(:players_teams, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:games, [:round_id])
    create index(:games, [:local_id])
    create index(:games, [:visitor_id])
  end
end
