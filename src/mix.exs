defmodule LiveFeedback.Mixfile do
  use Mix.Project

  def project do
    [app: :live_feedback,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
     compilers: [:phoenix] ++ Mix.compilers,
     test_coverage: [tool: Coverex.Task, log: :warn],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {LiveFeedback, []},
     applications: [:phoenix, :cowboy, :logger, :ssl, :erlcloud]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, github: "phoenixframework/phoenix"},
     {:cowboy, "~> 1.0"},
     {:phoenix_haml, github: "chrismccord/phoenix_haml"},
     {:ddbmodel, github: "jni-/ddbmodel"},
     {:jsx, github: "talentdeficit/jsx", override: true},
     {:meck, github: "eproxus/meck", override: true},
     {:coverex, ">= 0.0.0", only: :test}]
  end
end
