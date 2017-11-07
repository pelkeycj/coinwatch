defmodule Coinwatch.Relations.MarketUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coinwatch.Relations.MarketUser
  alias Coinwatch.Assets.Market
  alias Coinwatch.Accounts.User
  @moduledoc false

  schema "markets_users" do
    belongs_to :user, User
    belongs_to :market, Market

    timestamps()
  end

  def changeset(%MarketUser{} = mu, params \\ %{}) do
    mu
    |> cast(params, [:user_id, :market_id])
    |> validate_required([:user_id, :market_id])
  end
end
