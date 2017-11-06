defmodule Coinwatch.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Coinwatch.Repo
  alias Coinwatch.Accounts.User

  def for_token(%User{} = user), do: {:ok, "User:#{user.id}"}

  def for_token(_), do: {:error, "Unknown resource"}

  def from_token("User:" <> id), do: {:ok, Repo.get(User, String.to_integer(id))}

  def from_token(_), do: {:error, "Unknown resource"}

end
