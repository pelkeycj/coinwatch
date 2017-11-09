defmodule Coinwatch.Assets.Notification do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coinwatch.Assets.Notification


  schema "notifications" do
    field :high, :boolean, default: false
    field :notified, :boolean, default: false
    field :pair, :string
    field :threshold, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Notification{} = notification, attrs) do
    notification
    |> cast(attrs, [:pair, :threshold, :high, :notified])
    |> validate_required([:pair, :threshold, :high, :notified])
  end
end
