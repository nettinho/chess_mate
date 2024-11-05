defmodule ChessMate.Repo.Migrations.AddTeamDetails do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :initial_rank, :integer
      add :current_rank, :integer
      add :points, :float
      add :average_elo, :integer
    end
  end
end
