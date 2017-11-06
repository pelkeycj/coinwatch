defmodule CoinwatchWeb.SessionController do
  use CoinwatchWeb, :controller
  @moduledoc false

  #TODO issue with testing -> possibly check it out with postman

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
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> render("show.json", %{user: user, jwt: jwt})

      :error ->
        conn
        |> put_status(:unauthorized)
    end
  end


  #TODO use sign_out/1
  def delete(conn, _params) do
    IO.puts("delete session")
    jwt = Guardian.Plug.current_token(conn)
    Guardian.revoke!(jwt)

    conn
    |> put_status(:ok)
    |> send_resp(200, "Logged out.")
    #|> render("delete.json")
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
