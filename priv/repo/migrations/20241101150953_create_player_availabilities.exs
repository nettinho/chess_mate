defmodule ChessMate.Repo.Migrations.CreatePlayerAvailabilities do
  use Ecto.Migration

  def change do
    create table(:player_availabilities) do
      add :status, :string
      add :team_round_id, references(:team_rounds, on_delete: :delete_all)
      add :team_player_id, references(:players_teams, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:player_availabilities, [:team_round_id])
    create index(:player_availabilities, [:team_player_id])
  end
end
