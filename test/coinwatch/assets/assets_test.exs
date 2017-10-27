defmodule Coinwatch.AssetsTest do
  use Coinwatch.DataCase

  alias Coinwatch.Assets

  describe "market" do
    alias Coinwatch.Assets.Market

    @valid_attrs %{exchange: "some exchange", pair: "some pair", rate: "120.5"}
    @update_attrs %{exchange: "some updated exchange", pair: "some updated pair", rate: "456.7"}
    @invalid_attrs %{exchange: nil, pair: nil, rate: nil}

    def market_fixture(attrs \\ %{}) do
      {:ok, market} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Assets.create_market()

      market
    end

    test "list_market/0 returns all market" do
      market = market_fixture()
      assert Assets.list_market() == [market]
    end

    test "get_market!/1 returns the market with given id" do
      market = market_fixture()
      assert Assets.get_market!(market.id) == market
    end

    test "create_market/1 with valid data creates a market" do
      assert {:ok, %Market{} = market} = Assets.create_market(@valid_attrs)
      assert market.exchange == "some exchange"
      assert market.pair == "some pair"
      assert market.rate == Decimal.new("120.5")
    end

    test "create_market/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assets.create_market(@invalid_attrs)
    end

    test "update_market/2 with valid data updates the market" do
      market = market_fixture()
      assert {:ok, market} = Assets.update_market(market, @update_attrs)
      assert %Market{} = market
      assert market.exchange == "some updated exchange"
      assert market.pair == "some updated pair"
      assert market.rate == Decimal.new("456.7")
    end

    test "update_market/2 with invalid data returns error changeset" do
      market = market_fixture()
      assert {:error, %Ecto.Changeset{}} = Assets.update_market(market, @invalid_attrs)
      assert market == Assets.get_market!(market.id)
    end

    test "delete_market/1 deletes the market" do
      market = market_fixture()
      assert {:ok, %Market{}} = Assets.delete_market(market)
      assert_raise Ecto.NoResultsError, fn -> Assets.get_market!(market.id) end
    end

    test "change_market/1 returns a market changeset" do
      market = market_fixture()
      assert %Ecto.Changeset{} = Assets.change_market(market)
    end

    test "get_or_create/3 gets existing market when matching args" do
      market = market_fixture()
      existing = Assets.get_or_create(@valid_attrs[:exchange], @valid_attrs[:pair])
      assert market == existing
    end

    test "get_or_create/3 creates new market if no matching args" do
      assert %Market{exchange: "EXCHANGE", pair: "PAIR"}
             == Assets.get_or_create("EXCHANGE", "PAIR")
    end

    #these are basically testing the same thing as get_or_create/3 tests
    test "upsert_market/2 updates existing" do
      ex = @valid_attrs[:exchange]
      pair = @valid_attrs[:pair]
      rate = Decimal.new(100.5)
      Assets.create_market(@valid_attrs)
      {:ok, %Market{} = upserted} =  Assets.upsert_market(ex <> ":" <> pair, rate)
      assert %Market{} = upserted
      assert upserted.rate == rate
      assert upserted.exchange == ex
      assert upserted.pair == pair
    end

    test "upsert_market/2 creates new if no existing" do
      exch = "EXCHANGE"
      pair = "PAIR"
      rate = Decimal.new(1000)
      {:ok, %Market{} = upserted}  = Assets.upsert_market(exch <> ":" <> pair, rate)
      assert %Market{} = upserted
      assert upserted.rate == rate
      assert upserted.exchange == exch
      assert upserted.pair == pair
    end

  end
end
