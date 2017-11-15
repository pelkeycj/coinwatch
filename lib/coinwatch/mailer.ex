defmodule Coinwatch.Mailer do
  use Mailgun.Client,
      domain: Application.get_env(:coinwatch, :mailgun_domain),
      key: Application.get_env(:coinwatch, :mailgun_key)

  @from "coinwatch@mg.jdcrouse.org"

  #
  # the inputs are all the things we will store when a user requests updates
  # **idea: pass these in some sort of structure that can be unpacked
  #
  # e_addr: email address of user
  #   curr: symbol for currency that we are notifying them of
  #    val: user-specified critical value as a string
  def send_price_alert_email(e_addr, curr, val) do
    send_email to: e_addr,
               from: @from,
               subject: "Price Alert for " <> curr,
               text: alert_text(curr, val)
  end

  defp alert_text(curr, val) do
    "The price for " <> curr <> " has reached your desired alert value of " <> val <> "."
  end


end
