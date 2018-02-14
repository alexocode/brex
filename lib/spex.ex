defmodule Spex do
  @moduledoc """
  The main module. Provides shortcut functions to evaluate rules, reduce the
  results to a boolean and to check if some value satisfy some rules.

  For further information take a look at the following modules:
  - `Spex.Rule`
  - `Spex.Result`
  - `Spex.Operator`
  """

  alias Spex.{Rule, Types}

  @type evaluation :: Types.evaluation()
  @type one_or_many_results :: Types.result() | list(Types.result())
  @type one_or_many_rules :: Types.rule() | list(Types.rules())
  @type result :: Types.result()
  @type value :: Types.value()

  @spec evaluate(one_or_many_rules(), value()) :: evaluation()
  def evaluate(rules, value) do
    rules
    |> wrap()
    |> Rule.evaluate(value)
  end

  @spec result(one_or_many_rules(), value()) :: result()
  def result(rules, value) do
    rules
    |> wrap()
    |> Rule.result(value)
  end

  defp wrap(rules) when is_list(rules) do
    Spex.Operator.all(rules)
  end

  defp wrap(rule) do
    rule
  end

  @spec passed?(one_or_many_results()) :: boolean()
  def passed?(results) do
    results
    |> List.wrap()
    |> Enum.all?(&Spex.Result.passed?/1)
  end

  @spec satisfies?(one_or_many_rules(), value()) :: boolean()
  def satisfies?(rules, value) do
    rules
    |> result(value)
    |> passed?()
  end

  defdelegate number_of_clauses(rule), to: Rule
end
