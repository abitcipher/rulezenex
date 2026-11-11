defmodule Rulezenex.MixProject do
  use Mix.Project

  @version "0.1.1"
  @source_url "https://github.com/abitcipher/rulezenex"

  def project do
    [
      app: :rulezenex,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "GoRules ZEN (JSON Decision Model graphs) for Elixir, as a NIF",
      source_url: @source_url,
      package: package(),
      docs: docs()
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps do
    [
      {:rustler, "~> 0.38.0", runtime: false},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => "#{@source_url}/blob/main/CHANGELOG.md",
        "GoRules ZEN" => "https://github.com/gorules/zen"
      },
      files: ~w(
        lib
        native/rulezenex/src
        native/rulezenex/Cargo.toml
        native/rulezenex/Cargo.lock
        .formatter.exs
        mix.exs
        README.md
        CHANGELOG.md
        LICENSE
      )
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      extras: ["README.md", "CHANGELOG.md", "LICENSE"]
    ]
  end
end
