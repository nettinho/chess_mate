defmodule ChessMate.Repo.Migrations.CreateTeamRounds do
  use Ecto.Migration

  def change do
    create table(:team_rounds) do
      add :comments, :text
      add :lineup, {:array, :integer}
      add :round_id, references(:rounds, on_delete: :delete_all)
      add :team_id, references(:teams, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:team_rounds, [:round_id, :team_id])
  end
end
