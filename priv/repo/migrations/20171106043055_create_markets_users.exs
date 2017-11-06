defmodule Coinwatch.Repo.Migrations.CreateMarketsUsers do
  use Ecto.Migration

  def change do
    create table(:markets_users) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :market_id, references(:markets, on_delete: :delete_all)

      timestamps()
    end

    create index :markets_users, :user_id
    create index :markets_users, :market_id
    create unique_index(:markets_users, [:user_id, :market_id])

  end
end
