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
    [{:phoenix, github: "phoenixframework/phoenix", ref: "0cccab6ab1685c53d3053058f09c53ea1b60ce3f", override: true},
     {:cowboy, "~> 1.0"},
     {:phoenix_haml, github: "chrismccord/phoenix_haml"},
     {:ddbmodel, github: "jni-/ddbmodel"},
     {:jsx, github: "talentdeficit/jsx", override: true},
     {:meck, "0.8.2", override: true},
     {:mock, github: "jjh42/mock", only: :test},
     {:coverex, ">= 0.0.0", only: :test}]
  end
end
