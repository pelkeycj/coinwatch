defmodule CoinwatchWeb.SessionControllerTest do
  use CoinwatchWeb.ConnCase
  @moduledoc false


  #TODO test
  
  alias CoinwatchWeb.SessionController

  @create_attrs %{email: "some@email.com", password: "password", username: "username"}

  def fixture(:user) do
    {:ok, user} = Coinwatch.Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create session" do
    setup [:create_user]

    # user exists
      # is valid pw
      # is not valid pw
    # user does not exist

    test "renders session when valid user and password", %{conn: conn} do
      username = @create_attrs[:username]
      password = @create_attrs[:password]
      conn = SessionController.create(conn, %{username: username, password: password})

      IO.inspect(json_response(conn, 201))
      assert %{"token" => token} = json_response(conn, 201)["meta"]
      assert %{"username" => username}
             = json_response(conn, 201)["body"]
    end

    test "renders error when valid user and invalid password", %{conn: conn} do
      conn = SessionController.create(conn, %{username: "username", password: "wrong password"})
      assert response(conn, 401)
    end

    test "renders error when user does not exist", %{conn: conn} do
      conn = SessionController.create(conn, %{username: "fake", password: "password"})
      assert response(conn, 401)
    end

  end

  describe "delete session" do
    #remove token from conn
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
