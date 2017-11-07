defmodule CoinwatchWeb.MarketDataChannelTest do
  use CoinwatchWeb.ChannelCase

  alias CoinwatchWeb.MarketDataChannel
  alias Coinwatch.Assets

  def fixture(:market) do
    {:ok, market} = Assets.create_market(%{exchange: "exchange", pair: "pair", rate: Decimal.new(100)})
    market
  end

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(MarketDataChannel, "market_data:all")

    {:ok, socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  #test "shout broadcasts to market_data:all", %{socket: socket} do
  #  push socket, "shout", %{"hello" => "all"}
  #  assert_broadcast "shout", %{"hello" => "all"}
  #end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end

  test "join/3 replies with current market_data" do
    market = fixture(:market)
    {:ok, data, socket} = socket("test", %{some: :assign})
      |> subscribe_and_join(MarketDataChannel, "market_data:all")

    assert data.market_data == [market]
  end

  #TODO test handle out broadcasts all markets

end
