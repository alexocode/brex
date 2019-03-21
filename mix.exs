defmodule Brex.Mixfile do
  use Mix.Project

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

      # Docs
      name: "Brex",
      source_url: "https://github.com/Zeeker/brex",
      homepage_url: "https://github.com/Zeeker/brex",

      # Hex
      description: description(),
      package: package(),
      version: @version
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "spec/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # No Runtime
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},

      # Test
      {:excoveralls, "~> 0.8", only: :test},
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
        "GitHub" => "https://github.com/Zeeker/brex"
      },
      maintainers: ["Sascha Wolf <swolf.dev@gmail.com>"]
    ]
  end
end
