defmodule CoinwatchWeb.UserController do
  use CoinwatchWeb, :controller

  alias Coinwatch.Accounts
  alias Coinwatch.Accounts.User

  action_fallback CoinwatchWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  # creates and logs user into a session
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn = Guardian.Plug.api_sign_in(conn, user, :access)
      jwt = Guardian.Plug.current_token(conn)

      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render(CoinwatchWeb.SessionView, "show.json", user: user, jwt: jwt)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    with {:ok, %User{}} <- Accounts.delete_user(user) do
      conn
      |> put_status(:ok)
      |> render("delete.json")
    end
  end
end
