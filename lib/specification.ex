defmodule Specification do
  @moduledoc """
  The main module. Provides shortcut functions to evaluate rules, reduce the
  results to a boolean and to check if some value satisfy some rules.

  For further information take a look at the following modules:
  - `Specification.Rule`
  - `Specification.Result`
  - `Specification.Operator`
  """

  alias Specification.Result
  alias Specification.Types

  def evaluate(rules, value) when is_list(rules) do
    rules
    |> Specification.Operator.all()
    |> evaluate(value)
  end

  def evaluate(rule, value) do
    result = Specification.Rule.evaluate(rule, value)

    %Result{
      rule: rule,
      result: result,
      value: value
    }
  end

  def passed?(results) do
    results
    |> List.wrap()
    |> Enum.all?()
  end

  @spec satisfies?(Types.rules() | Types.rule(), Types.value()) :: boolean()
  def satisfies?(rules, value) do
    rules
    |> evaluate(value)
    |> passed?()
  end

  @doc """
  Returns the number of clauses this rule has.

  ## Examples

      iex> Specification.number_of_clauses([])
      0

      iex> rules = [fn _ -> true end]
      iex> Specification.number_of_clauses(rules)
      1

      iex> rules = [fn _ -> true end, Specification.Operator.any(fn _ -> false end, fn _ -> true end)]
      iex> Specification.number_of_clauses(rules)
      3
  """
  @spec number_of_clauses(Types.rules()) :: non_neg_integer()
  def number_of_clauses(rules) when is_list(rules) do
    Enum.reduce(rules, 0, &(&2 + number_of_clauses(&1)))
  end

  def number_of_clauses({_operator, clauses}) do
    number_of_clauses(clauses)
  end

  def number_of_clauses(_) do
    1
  end
end
