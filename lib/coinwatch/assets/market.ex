defmodule Coinwatch.Assets.Market do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coinwatch.Assets.Market


  schema "markets" do
    field :exchange, :string
    field :pair, :string
    field :rate, :decimal

    timestamps()
  end

  @doc false
  def changeset(%Market{} = market, attrs) do
    market
    |> cast(attrs, [:exchange, :pair])
    |> validate_required([:exchange, :pair])
  end
end
