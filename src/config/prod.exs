use Mix.Config

# ## SSL Support
#
# To get SSL working, you will need to set:
#
#     https: [port: 443,
#             keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#             certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables point to a file on
# disk for the key and cert.

config :phoenix, LiveFeedback.Router,
  url: [host: "example.com"],
  http: [port: System.get_env("PORT")],
  secret_key_base: System.get_env("SESSION_SECRET") || "N4dz9FBjLlWmGaL6jl+Yw0wO9BgZh9OhWJgTcAAb1J+RfjZ+ilUOXyFD9LuMz3SXF/fttAYkfgcnZ0peayst1Q=="

config :logger, :console,
  level: :info
