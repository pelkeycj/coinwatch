# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Coinwatch.Repo.insert!(%Coinwatch.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Coinwatch.Repo
alias Coinwatch.Assets.Notification

Repo.delete_all(Notification)

Repo.insert(%Notification{pair: "btcusd", threshold: 340, high: true, notified: false, last_rate: 3})
Repo.insert(%Notification{pair: "btcusd", threshold: 10000, high: false, notified: false, last_rate: 100000})
Repo.insert(%Notification{pair: "btcusd", threshold: 340, high: true, notified: true, last_rate: 3})

# note = Coinwatch.Assets.get_notification!(7)
# Coinwatch.Assets.update_notification(note, %{threshold: 10000})
# Coinwatch.Assets.check_passed_below(note)
# Coinwatch.Assets.update_most_recent_price_high(note) --> WORKS
#    for mark <- marks do
#      IO.puts("market rate" <> Decimal.to_string(mark.rate))
#      IO.puts("currenct high: ")
#      if mark.rate > high do
#        high = mark.rate
#        IO.puts("updated high to rate" <> Decimal.to_string(^high))
#        high_mark = mark.id
#      end
#    end
