defmodule DS.MixProject do
  use Mix.Project

  def project do
    [
      app: :ds,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {DS.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:ua_inspector, "~> 0.20"},
      {:jason, "~> 1.1"}
    ]
  end
end
