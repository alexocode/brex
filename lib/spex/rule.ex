defmodule Spex.Rule do
  # One __could__ generate this: but that would require writing a recursive AST generating macro, so nope
  # @type t :: Rule.Function.t() | Rule.Module.t() | Rule.Operator.t() | Rule.Struct.t()

  alias Spex.Types

  @type t :: any()

  defprotocol Evaluable do
    @moduledoc """
    The main rule protocol. Each rule needs to implement this protocol to be
    considered a rule.

    Take a look at `Spex.Rule.Struct` for details on implementing struct based
    custom rules.
    """

    @spec evaluate(t(), Types.value()) :: Types.evaluation()
    def evaluate(rule, value)
  end

  @doc """
  Calls `evaluate/2` with the given rule and value and wraps it into a
  `Spex.Result` struct.
  """
  @spec result(t(), Types.value()) :: Types.result()
  def result(rule, value) do
    %Spex.Result{
      evaluation: Evaluable.evaluate(rule, value),
      rule: rule,
      value: value
    }
  end

  @doc """
  Returns the type or rather the implementation module for
  `Spex.Rule.Evaluable`.

  ## Examples

      iex> Spex.Rule.type(&is_list/1)
      Spex.Rule.Evaluable.Function

      iex> Spex.Rule.type(SomeModuleRule)
      Spex.Rule.Evaluable.Atom

      iex> Spex.Rule.type(Spex.Operator.All.new([]))
      Spex.Rule.Evaluable.Spex.Operator.All

      iex> Spex.Rule.type("something")
      nil
  """
  @spec type(t()) :: module() | nil
  def type(rule), do: Evaluable.impl_for(rule)

  @doc """
  Returns the number of clauses this rule has.

  ## Examples

      iex> Spex.Rule.number_of_clauses([])
      0

      iex> rules = [fn _ -> true end]
      iex> Spex.Rule.number_of_clauses(rules)
      1

      iex> rules = [fn _ -> true end, Spex.any(fn _ -> false end, fn _ -> true end)]
      iex> Spex.Rule.number_of_clauses(rules)
      3
  """
  @spec number_of_clauses(t() | list(t())) :: non_neg_integer()
  def number_of_clauses(rules) when is_list(rules) do
    rules
    |> Enum.map(&number_of_clauses/1)
    |> Enum.sum()
  end

  def number_of_clauses(rule) do
    case Spex.Operator.clauses(rule) do
      {:ok, clauses} -> number_of_clauses(clauses)
      :error -> 1
    end
  end
end
