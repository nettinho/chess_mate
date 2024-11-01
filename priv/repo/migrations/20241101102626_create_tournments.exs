defmodule ChessMate.Repo.Migrations.CreateTournments do
  use Ecto.Migration

  def change do
    create table(:tournments) do
      add :code, :string
      add :name, :string
      add :when, :string
      add :rate, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tournments, [:name])
  end
end
