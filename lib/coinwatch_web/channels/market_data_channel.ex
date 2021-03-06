defmodule CoinwatchWeb.MarketDataChannel do
  use CoinwatchWeb, :channel

  def join("market_data:all", payload, socket) do
    if authorized?(payload) do
      data = %{market_data: Coinwatch.Assets.list_market()}
      {:ok, data,  socket}
      #{:reply, {:ok, data}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (market_data:lobby).
  #def handle_in("shout", payload, socket) do
  #  broadcast socket, "shout", payload
  #  {:noreply, socket}
  #end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
