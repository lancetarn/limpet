# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :limpet,
  ecto_repos: [Limpet.Repo]

# Configures the endpoint
config :limpet, Limpet.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XGUY3fumA/suN/5K5ZCiG7KcgTvcOL138+P3proZ639xK1BCexfKx0u7BT1Zu2zA",
  render_errors: [view: Limpet.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Limpet.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :limpet, Limpet.Secrets,
  salt: "sU!!LI_%0sEvOfI~S0uTiVH@yQe2hg$EXw~fkevdABwOrGZe*dnvzQWPUr~ALY-&"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
