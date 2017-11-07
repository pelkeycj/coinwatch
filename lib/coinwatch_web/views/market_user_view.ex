defmodule CoinwatchWeb.MarketUserView do
  use CoinwatchWeb, :view
  alias CoinwatchWeb.UserView

  def render("show.json", %{user: user}) do
    UserView.render("show.json", %{user: user})
  end
end
