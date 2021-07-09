defmodule HackerNews.MixProject do
  use Mix.Project

  def project do
    [
      app: :hacker_news,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {HackerNews.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2.2"},
      {:mock, "~> 0.3.0", only: :test},
      {:plug_cowboy, "~> 2.0"},
      {:tesla, "~> 1.4.1"}
    ]
  end
end
