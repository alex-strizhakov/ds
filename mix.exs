defmodule DS.MixProject do
  use Mix.Project

  def project do
    [
      app: :ds,
      version: "1.1",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/alex-strizhakov/ds"
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
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:plug_cowboy, "~> 2.1"},
      {:ua_inspector, "~> 1.0"},
      {:jason, "~> 1.1"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp description do
    "This module is designed to facilitate the Device structure (Plug.Conn.assign) and easy connection to other projects."
  end

  defp package do
    [
      licenses: ["MIT License"],
      links: %{"GitHub" => "https://github.com/alex-strizhakov/ds"}
    ]
  end
end
