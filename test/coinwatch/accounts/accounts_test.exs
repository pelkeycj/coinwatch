defmodule Coinwatch.AccountsTest do
  use Coinwatch.DataCase

  alias Coinwatch.Accounts

  describe "users" do
    alias Coinwatch.Accounts.User

    @valid_attrs %{email: "some@email.com",
      username: "some username", password: "some password"}

    @update_attrs %{email: "some_updated@email.com", username: "updated username",
                    password: "updated_password"}
    @invalid_attrs %{email: nil, username: nil, password: nil, password_confirmation: nil}

    @invalid_email1 %{email: "bad", username: "username", password: "password"}
    @invalid_email2 %{email: "", username: "username", password: "password"}
    @invalid_email3 %{email: "@no.com", username: "username", password: "password"}
    @invalid_email4 %{email: "bad.com", username: "username", password: "password"}

    @invalid_pw %{email: "some@email.com", username: "username", password: "short"}


    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

        user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end


    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@email.com"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid pw lenght returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_pw)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 with invalid email1 returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_email1)
    end

    test "create_user/1 with invalid email2 returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_email2)
    end

    test "create_user/1 with invalid email3 returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_email4)
    end

    test "create_user/1 with invalid email4 returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_email1)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some_updated@email.com"
      assert user.username == "updated username"
    end

    test "update_user/2 with invalid pw length returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_pw)
      assert user == Accounts.get_user!(user.id)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "update_user/2 with invalid email1 returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_email1)
      assert user == Accounts.get_user!(user.id)
    end

    test "update_user/2 with invalid email2 returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_email2)
      assert user == Accounts.get_user!(user.id)
    end

    test "update_user/2 with invalid email3 returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_email3)
      assert user == Accounts.get_user!(user.id)
    end

    test "update_user/2 with invalid email4 returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_email4)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
