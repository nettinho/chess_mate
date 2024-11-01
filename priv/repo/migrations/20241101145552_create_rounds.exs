defmodule ChessMate.Repo.Migrations.CreateRounds do
  use Ecto.Migration

  def change do
    create table(:rounds) do
      add :round, :integer
      add :timestamp, :utc_datetime
      add :tournment_id, references(:tournments, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:rounds, [:tournment_id])
  end
end
