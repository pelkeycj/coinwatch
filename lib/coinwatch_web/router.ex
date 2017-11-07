defmodule CoinwatchWeb.Router do
  use CoinwatchWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    # look for a token in the header and validate it
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  #TODO eventually remove browser access altogether?
  scope "/", CoinwatchWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
   scope "/api/0", CoinwatchWeb do
     pipe_through :api

     post "/session", SessionController, :create # login
     delete "/session", SessionController, :delete #logout

     resources "/markets", MarketController, except: [:new, :edit]
     resources "/users", UserController, except: [:new, :edit]

     post "/market_user", MarketUserController, :create
     delete "/market_user", MarketUserController, :delete
   end
end
