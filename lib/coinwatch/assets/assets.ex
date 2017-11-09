defmodule Coinwatch.Assets do
  @moduledoc """
  The Assets context.
  """

  import Ecto.Query, warn: false
  alias Coinwatch.Repo

  alias Coinwatch.Assets.Market

  @doc """
  Returns the list of market.

  ## Examples

      iex> list_market()
      [%Market{}, ...]

  """
  def list_market do
    Repo.all(Market)
  end

  @doc """
  Gets a single market.

  Raises `Ecto.NoResultsError` if the Market does not exist.

  ## Examples

      iex> get_market!(123)
      %Market{}

      iex> get_market!(456)
      ** (Ecto.NoResultsError)

  """
  def get_market!(id), do: Repo.get!(Market, id)

  @doc """
  Creates a market.

  ## Examples

      iex> create_market(%{field: value})
      {:ok, %Market{}}

      iex> create_market(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_market(attrs \\ %{}) do
    %Market{}
    |> Market.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a market.

  ## Examples

      iex> update_market(market, %{field: new_value})
      {:ok, %Market{}}

      iex> update_market(market, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_market(%Market{} = market, attrs) do
    market
    |> Market.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Market.

  ## Examples

      iex> delete_market(market)
      {:ok, %Market{}}

      iex> delete_market(market)
      {:error, %Ecto.Changeset{}}

  """
  def delete_market(%Market{} = market) do
    Repo.delete(market)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking market changes.

  ## Examples

      iex> change_market(market)
      %Ecto.Changeset{source: %Market{}}

  """
  def change_market(%Market{} = market) do
    Market.changeset(market, %{})
  end

  #Returns the current price for all supported markets in JSON.
  #Some values may be out of date by a few seconds.
  #### Data is in the form "EXCHANGE:PAIR" : PRICE in a list
  def market_prices_URL do
    "https://api.cryptowat.ch/markets/prices"
  end

  # Returns the market summary for all supported markets.
  # Some values may be out of date by a few seconds.
  def market_summary_URL do
    "https://api.cryptowat.ch/markets/summaries"
  end

  def get_decoded_URL(url) do
    res = HTTPoison.get!(url)
    Poison.decode(res.body)
  end

  def isolate_result(res) do
    with {:ok, result} <- Map.fetch(res, "result") do
      result
    end
  end

  @doc """
    Gets all markets and their prices. For each obtained data,
    a Market struct is either created or updated to contain the latest
    price information.
  """
  def upsert_markets do
    with {:ok, map} <- get_decoded_URL(market_prices_URL()) do
      map
      |> isolate_result()
      |> Enum.each(fn {k, v} ->
          upsert_market(k, v)
        end)
    end
  end


  @doc """
    Updates or inserts a Market with the new rate.
  """
  def upsert_market(exchangepair, rate) do
    list = String.split(exchangepair, ":")
    exchange = List.first(list)
    pair = List.last(list)

    get_or_create(exchange, pair)
    |> Market.changeset(%{rate: rate})
    |> Repo.insert_or_update()
    |> broadcast_to_watchers()
  end

  @doc """
    Retrieves an existing Market matching the exchange and pair arguments or
    creates a new one.
  """
  def get_or_create(exchange, pair) do
    case Repo.get_by(Market, exchange: exchange, pair: pair) do
      nil ->
        %Market{exchange: exchange, pair: pair}
      market ->
        market
    end
  end

  @doc """
    Broadcasts market to user's channel if they follow this market.
  """
  def broadcast_to_watchers(market) do
    #TODO probably just send all market data up?
    # or should we broadcast each individually?
    #IO.inspect(market)
    market
  end


  alias Coinwatch.Assets.Notification

  @doc """
  Returns the list of notifications.

  ## Examples

      iex> list_notifications()
      [%Notification{}, ...]

  """
  def list_notifications do
    Repo.all(Notification)
  end

  @doc """
  Gets a single notification.

  Raises `Ecto.NoResultsError` if the Notification does not exist.

  ## Examples

      iex> get_notification!(123)
      %Notification{}

      iex> get_notification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notification!(id), do: Repo.get!(Notification, id)

  @doc """
  Creates a notification.

  ## Examples

      iex> create_notification(%{field: value})
      {:ok, %Notification{}}

      iex> create_notification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notification(attrs \\ %{}) do
    %Notification{}
    |> Notification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a notification.

  ## Examples

      iex> update_notification(notification, %{field: new_value})
      {:ok, %Notification{}}

      iex> update_notification(notification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notification(%Notification{} = notification, attrs) do
    notification
    |> Notification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Notification.

  ## Examples

      iex> delete_notification(notification)
      {:ok, %Notification{}}

      iex> delete_notification(notification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notification(%Notification{} = notification) do
    Repo.delete(notification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notification changes.

  ## Examples

      iex> change_notification(notification)
      %Ecto.Changeset{source: %Notification{}}

  """
  def change_notification(%Notification{} = notification) do
    Notification.changeset(notification, %{})
  end
end
