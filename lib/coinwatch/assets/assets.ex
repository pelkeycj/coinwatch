defmodule Coinwatch.Assets do
  @moduledoc """
  The Assets context.
  """

  import Ecto.Query, warn: false
  alias Coinwatch.Repo

  alias Coinwatch.Assets.Market


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

      broadcast_markets()
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
    Broadcasts all market data in one blob to members of channel
    market_data:all
  """
  #TODO not sure if this works correctly, may have to push differently
  def broadcast_markets() do
    CoinwatchWeb.Endpoint.broadcast("market_data:all", "new_data", %{all_markets: list_markets()})
  end

end
