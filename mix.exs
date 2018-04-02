defmodule Spex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :spex,
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
      name: "Spex",
      source_url: "https://github.com/Zeeker/spex",
      homepage_url: "https://github.com/Zeeker/spex",

      # Hex
      description: description(),
      package: package(),
      version: "0.1.0"
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
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},

      # Test
      {:excoveralls, "~> 0.8", only: :test},
      {:espec, github: "antonmi/espec", only: :test}
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
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/Zeeker/spex"
      },
      maintainers: ["Sascha Wolf <swolf.dev@gmail.com>"]
    ]
  end
end
