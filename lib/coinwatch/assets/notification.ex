defmodule Coinwatch.Assets.Notification do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coinwatch.Assets.Notification


  schema "notifications" do
    # true if high threshold (notify when value goes above this),
    # false if low threshold (notify if value goes below this)
    field :high, :boolean, default: true
    # used to delete notifications after they have been notified
    # may be unnecessary--can delete immediately but just to be safe
    field :notified, :boolean, default: false
    # value to notify user upon passing
    field :threshold, :integer
    # the user who requested the notification
    field :user, :id
    # the identifier for the currency that is being observed
    field :pair, :string

    timestamps()
  end

  @doc false
  def changeset(%Notification{} = notification, attrs) do
    notification
    |> cast(attrs, [:threshold, :high, :notified, :user_id, :pair])
    |> validate_required([:threshold, :high, :notified, :user_id, :pair])
  end
end
