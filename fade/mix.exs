defmodule Fade.MixProject do
  use Mix.Project

  def project do
    [
      app: :fade,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:typed_struct, "~> 0.2.1"},
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.8"},
      {:uuid, "~> 1.1"}
      # {:amqp_client, "~> 3.9"}
      # {:amqp, "~> 3.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
