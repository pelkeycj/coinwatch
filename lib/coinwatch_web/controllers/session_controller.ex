defmodule SessionController do
  use CoinwatchWeb, :controller
  @moduledoc false

  alias Coinwatch.Accounts.User
  alias Coinwatch.Repo

  # create a session jwt if user can be authenticated
  def create(conn, %{"username" => username, "password" => password}) do
    case authenticate(username, password) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user, :access)
        jwt = Guardian.Plug.current_token(new_conn)
        new_conn
        |> put_status(:created)
        |> render("show.json", %{user: user, jwt: jwt})

      :error ->
        conn
        |> put_status(:unauthorized)
    end

  end

  def delete(conn, _params) do
    Guardian.Plug.current_token(conn)
    |> Guardian.revoke!()

    conn
    |> put_status(:ok)
  end

  defp authenticate(username, password) do
    user = Repo.get_by(User, username: username)
    case check_password(user, password) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  def check_password(nil, _) do
    Comeonin.Argon2.dummy_checkpw()
  end

  def check_password(user, password) do
    Comeonin.Argon2.checkpw(password, user.password_hash)
  end
end
