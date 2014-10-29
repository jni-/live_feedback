# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the router
config :phoenix, LiveFeedback.Router,
  url: [host: "localhost"],
  http: [port: System.get_env("PORT")],
  secret_key_base: "N4dz9FBjLlWmGaL6jl+Yw0wO9BgZh9OhWJgTcAAb1J+RfjZ+ilUOXyFD9LuMz3SXF/fttAYkfgcnZ0peayst1Q==",
  catch_errors: true,
  debug_errors: false,
  error_controller: LiveFeedback.PageController

config :phoenix, :template_engines,
  haml: PhoenixHaml.Engine

# Session configuration
config :phoenix, LiveFeedback.Router,
  session: [store: :cookie,
            key: "_live_feedback_key"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :live_feedback, :reloads,
  key: System.get_env("DEPLOYMENT_KEY") || "default-dev-key"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
