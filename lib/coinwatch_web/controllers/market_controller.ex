defmodule CoinwatchWeb.MarketController do
  use CoinwatchWeb, :controller

  alias Coinwatch.Assets
  alias Coinwatch.Assets.Market

  action_fallback CoinwatchWeb.FallbackController

  def index(conn, _params) do
    market = Assets.list_market()
    render(conn, "index.json", market: market)
  end

  def create(conn, %{"market" => market_params}) do
    with {:ok, %Market{} = market} <- Assets.create_market(market_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", market_path(conn, :show, market))
      |> render("show.json", market: market)
    end
  end

  def show(conn, %{"id" => id}) do
    market = Assets.get_market!(id)
    render(conn, "show.json", market: market)
  end

  def update(conn, %{"id" => id, "market" => market_params}) do
    market = Assets.get_market!(id)

    with {:ok, %Market{} = market} <- Assets.update_market(market, market_params) do
      render(conn, "show.json", market: market)
    end
  end

  def delete(conn, %{"id" => id}) do
    market = Assets.get_market!(id)
    with {:ok, %Market{}} <- Assets.delete_market(market) do
      send_resp(conn, :no_content, "")
    end
  end
end
