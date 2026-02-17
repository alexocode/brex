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
      source_url: "https://github.com/sascha-wolf/brex",
      homepage_url: "https://github.com/sascha-wolf/brex",

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
      # Runtime
      {:tracer, github: "systemic-engineer/tracer"},

      # No Runtime
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},

      # Test
      {:credo, "~> 1.4", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13", only: :test},
      {:espec, "~> 1.6", only: :test},
      {:ssl_verify_fun, "~> 1.1.7", only: :test, override: true}
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
        "GitHub" => "https://github.com/sascha-wolf/brex"
      },
      maintainers: ["Sascha Wolf <swolf.dev@gmail.com>"]
    ]
  end
end
