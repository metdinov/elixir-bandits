# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Default Secret Key
secret_key = :crypto.strong_rand_bytes(60) |> Base.url_encode64() |> binary_part(0, 60)

# Configures the endpoint
config :elixir_bandits, ElixirBanditsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UVT4Ll9ND9VF0OexMnlOlVc52ein+p7hyJXnx1CcPq7fxsSlCQgkJhBJKYdilvD5",
  render_errors: [view: ElixirBanditsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ElixirBandits.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian
config :elixir_bandits, ElixirBandits.Guardian,
  issuer: "ElixirBandits",
  ttl: {1, :days},
  secret_key: System.get_env("GUARDIAN_SECRET_KEY") || secret_key

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
