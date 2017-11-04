use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :coinwatch, CoinwatchWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :coinwatch, Coinwatch.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "coinwatch_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

#improve test time
config :argon2_elixir,
       t_cost: 2,
       m_cost: 12
