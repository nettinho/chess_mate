defmodule ChessMate.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :code, :string
      add :name, :string
      add :tournment_id, references(:tournments, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:teams, [:tournment_id])
  end
end
