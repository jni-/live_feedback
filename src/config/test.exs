use Mix.Config

config :phoenix, LiveFeedback.Router,
  http: [port: System.get_env("PORT") || 4001],
  catch_errors: false

config :live_feedback, :reloads,
  key: "12345"

config :live_feedback, :admin,
  password: "right password"
