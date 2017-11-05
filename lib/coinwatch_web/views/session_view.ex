defmodule CoinwatchWeb.SessionView do
  use CoinwatchWeb, :view
  @moduledoc false

  def render("show.json", %{user: user, jwt: jwt}) do
    %{
      data: user_render(user),
      meta: %{token: jwt}
    }
  end

  def user_render(user) do
    %{username: user.username, email: user.email,
      id: user.id}
  end
end
