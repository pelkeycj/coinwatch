defmodule CoinwatchWeb.PageController do
  use CoinwatchWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
