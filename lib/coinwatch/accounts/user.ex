defmodule Coinwatch.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coinwatch.Accounts.User

  #TODO watched markets
  #TODO (eventually?) blog posts
  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    # rate limit failed login attempts
    field :pw_tries, :integer, default: 0
    field :pw_last_try, :utc_datetime

    #used when registering
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> validate_format(:email, email_regex())
    |> validate_password(:password)
    |> put_pass_hash()
    |> validate_required([:username, :email, :password_hash])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  # just to ensure '@', should probaby use confirmation email additionally
  def email_regex do
    ~r/(\w+)@([\w.]+)/
  end

  # from Comeonin docs
  def validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case valid_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  def put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end

  def put_pass_hash(changeset), do: changeset

  # require 8 character passwords
  def valid_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end

  def valid_password?(_), do: {:error, "password is too short"}

  # by Nat Tuck
  def update_tries(throttle, prev) do
    if throttle do
      prev + 1
    else
      1
    end
  end

  # by Nat Tuck
  def throttle_attempts(user) do
    y2k = DateTime.from_naive!(~N[2000-01-01 00:00:00], "Etc/UTC")
    previous = DateTime.to_unix(user.pw_last_try || y2k)
    now = DateTime.to_unix(DateTime.utc_now())
    throttle = (now - previous) < 3600

    if (throttle && user.pw_tries > 5) do
      nil
    else
      changes = %{
        pw_tries: update_tries(throttle, user.pw_tries),
        pw_last_try: DateTime.utc_now()
      }
      {:ok, _user} = Ecto.Changeset.cast(user, changes, [:pw_tries, :pw_last_try])
      |> Coinwatch.Repo.update

    end
  end
end
