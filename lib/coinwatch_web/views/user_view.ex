defmodule CoinwatchWeb.UserView do
  use CoinwatchWeb, :view
  alias CoinwatchWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      markets: get_markets(user)}
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def get_markets(user) do
    user = Coinwatch.Repo.preload(user, :markets)
    render_many(user.markets, CoinwatchWeb.MarketView, "market.json")
  end
end
