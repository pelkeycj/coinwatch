defmodule Coinwatch.Repo.Migrations.CreateMarket do
  use Ecto.Migration

  def change do
    create table(:markets) do
      add :exchange, :string, null: false
      add :pair, :string, null: false
      add :rate, :decimal, default: 0, null: false

      timestamps()
    end

    create unique_index(:markets, [:exchange, :pair])

  end
end
