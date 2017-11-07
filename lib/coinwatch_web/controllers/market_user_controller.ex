defmodule CoinwatchWeb.MarketUserController do
  use CoinwatchWeb, :controller

  alias Coinwatch.Relations
  alias Coinwatch.Relations.MarketUser
  alias Coinwatch.Accounts

  #TODO ensure user is logged in?

  # user follows market, renders user.json
  def create(conn, %{"market_user" => params}) do
    with {:ok, %MarketUser{} = mu} <- Relations.create_market_user(params) do
      user = Accounts.get_user!(mu.user_id)
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def delete(conn, %{"market_user" => params}) do
    mu = Relations.get_market_user!(params)
    user = Accounts.get_user!(mu.user_id)

    with {:ok, %MarketUser{}} <- Relations.delete_market_user(mu) do
      conn
      |> put_status(:ok)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end
end
