defmodule Specification.Mixfile do
  use Mix.Project

  def project do
    [
      app: :specification,
      version: "0.1.0",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      preferred_cli_env: [espec: :test],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
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
      {:espec, github: "antonmi/espec", only: :test}
    ]
  end

  def aliases do
    [
      test: "espec"
    ]
  end
end
