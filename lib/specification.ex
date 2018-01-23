defmodule Specification do
  @moduledoc """
  The main module. Provides shortcut functions to evaluate rules, reduce the
  results to a boolean and to check if some value satisfy some rules.

  For further information take a look at the following modules:
  - `Specification.Rule`
  - `Specification.Result`
  - `Specification.Operator`
  """

  alias Specification.{Rule, Types}

  def evaluate(rules, value) do
    rules
    |> wrap()
    |> Rule.evaluate(value)
  end

  def result(rules, value) do
    rules
    |> wrap()
    |> Rule.result(value)
  end

  defp wrap(rules) when is_list(rules) do
    Specification.Operator.all(rules)
  end

  defp wrap(rule) do
    rule
  end

  def passed?(results) do
    results
    |> List.wrap()
    |> Enum.all?()
  end

  @spec satisfies?(Types.rules() | Types.rule(), Types.value()) :: boolean()
  def satisfies?(rules, value) do
    rules
    |> result(value)
    |> passed?()
  end

  defdelegate number_of_clauses(rule), to: Rule
end
