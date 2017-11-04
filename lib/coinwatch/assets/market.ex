defmodule Coinwatch.Assets.Market do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coinwatch.Assets.Market

  #TODO? if we can figure out how to graph nicely in js,
  # we could store a history of prices and present it as a graph
  schema "markets" do
    field :exchange, :string
    field :pair, :string
    field :rate, :decimal

    timestamps()
  end

  @doc false
  def changeset(%Market{} = market, attrs) do
    market
    |> cast(attrs, [:exchange, :pair, :rate])
    |> validate_required([:exchange, :pair])
  end
end
