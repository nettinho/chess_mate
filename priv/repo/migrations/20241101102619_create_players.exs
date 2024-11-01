defmodule ChessMate.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :fide, :string
      add :name, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:players, [:user_id])
    create unique_index(:players, [:fide])
  end
end
