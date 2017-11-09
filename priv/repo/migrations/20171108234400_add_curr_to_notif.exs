defmodule Coinwatch.Repo.Migrations.AddCurrToNotif do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      add :pair, :string
    end
  end
end
