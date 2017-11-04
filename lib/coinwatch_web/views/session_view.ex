defmodule CoinwatchWeb.SessionView do
  use CoinwatchWeb, :view
  @moduledoc false

  alias CoinwatchWeb.UserView

  def render("show.json", %{user: user, jwt: jwt}) do
    %{
      data: user_render(user),
      meta: %{token: jwt}
    }
  end

  def user_render(user) do
    %{username: user.username, email: user.email,
      id: user.id, password_hash: user.password_hash}
  end
end
