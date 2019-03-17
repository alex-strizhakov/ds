defmodule DS.MixProject do
  use Mix.Project

  def project do
    [
      app: :ds,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
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

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib", "test/support"]

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:ua_inspector, "~> 0.20"},
      {:jason, "~> 1.1"}
    ]
  end
end
