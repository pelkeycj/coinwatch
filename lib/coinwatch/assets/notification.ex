defmodule Coinwatch.Assets.Notification do
  use Ecto.Schema
  import Ecto.Changeset
  alias Coinwatch.Assets.Notification

  schema "notifications" do
    # high is true if we want to notify when the value goes ABOVE the threshold
    field :high, :boolean, default: false
    field :notified, :boolean, default: false
    field :pair, :string
    field :threshold, :integer
    field :user_id, :id
    field :last_rate, :decimal, default: Decimal.new(0.0)
    field :market_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Notification{} = notification, attrs) do
    notification
    |> cast(attrs, [:pair, :threshold, :high, :notified, :last_rate, :market_id])
    |> validate_required([:pair, :threshold, :high, :notified])
  end
end

# note = %Coinwatch.Assets.Notification{pair: "BTCUSD", threshold: 340, high: true, notified: false, last_rate: 3}

# Coinwatch.Mailer.send_signup_confirmation(note)
# Coinwatch.Mailer.send_price_alert_email(note)
