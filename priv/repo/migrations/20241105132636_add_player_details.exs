defmodule ChessMate.Repo.Migrations.AddPlayerDetails do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :country, :string
      add :gender, :string
      add :birth_year, :integer
    end
  end
end
