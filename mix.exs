defmodule Brex.Mixfile do
  use Mix.Project

  @source_url "https://github.com/sascha-wolf/brex"
  @version "version" |> File.read!() |> String.trim()

  def project do
    [
      app: :brex,
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      preferred_cli_env: [
        espec: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      test_coverage: [tool: ExCoveralls],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      docs: docs(),

      # Hex
      description: description(),
      package: package(),
      version: @version
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "spec/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # No Runtime
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},

      # Test
      {:credo, "~> 1.4", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13", only: :test},
      {:espec, "~> 1.6", only: :test}
    ]
  end

  def aliases do
    [
      test: "espec"
    ]
  end

  def description do
    "A Specification Pattern implementation in Elixir"
  end

  def package do
    [
      files: ["lib", "mix.exs", "LICENSE*", "README*", "version"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "#{@source_url}/blob/main/CHANGELOG.md",
        "GitHub" => @source_url
      },
      maintainers: ["Sascha Wolf <swolf.dev@gmail.com>"]
    ]
  end

  def docs do
    [
      main: "readme",
      source_ref: "v#{@source_url}",
      source_url: @source_url,
      homepage_url: @source_url,
      extras: [
        "README.md",
        "CHANGELOG.md"
      ]
    ]
  end
end
