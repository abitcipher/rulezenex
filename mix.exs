defmodule Rulezenex.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :rulezenex,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "GoRules ZEN (JSON Decision Model graphs) for Elixir, as a NIF",
      source_url: "https://github.com/abitcipher/rulezenex"
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps do
    [
      {:rustler, "~> 0.38.0", runtime: false},
      {:jason, "~> 1.4"}
    ]
  end
end
