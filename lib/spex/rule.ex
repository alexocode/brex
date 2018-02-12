defmodule Spex.Rule do
  alias Spex.{Result, Rule, Types}

  rule_types = [
    Rule.Function,
    Rule.Module,
    Rule.Operator,
    Rule.Struct
  ]

  @moduledoc """
  This module represents the central API to evaluate a given rule for a given
  value.

  ## Rule Types

  It currently supports the following rule types:
  #{
    rule_types
    |> Enum.map(&"- #{inspect(&1)}")
    |> Enum.join("\n")
  }

  ## Behaviour

  It also serves as the behaviour for all rule types. For this it provides the
  following callbacks:
  - `is_rule_of_type?/1` used to find the correct rule type
  - `evaluate/2` evaluates the given rule with the given value, returns the
  result of the evaluation
  - `result/2` returns a `Spex.Result` containing the evaluation result
  """

  # One __could__ generate this: but that would require writing a recursive AST generating macro, so nope
  @type t :: Rule.Function.t() | Rule.Module.t() | Rule.Operator.t() | Rule.Struct.t()

  @callback is_rule_of_type?(any()) :: boolean()
  @callback evaluate(t(), Types.value()) :: Types.result_value()
  @callback result(t(), Types.value()) :: Types.result()

  defmacro __using__(_which) do
    quote do
      @before_compile unquote(__MODULE__)
      @behaviour unquote(__MODULE__)

      def result(rule, value) do
        unquote(__MODULE__).result(rule, value)
      end

      defoverridable result: 2
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def is_rule_of_type?(_other), do: false
    end
  end

  @rule_types rule_types

  def is_rule?(rule) do
    Enum.any?(@rule_types, &apply(&1, :is_rule_of_type?, [rule]))
  end

  def type(rule) do
    Enum.find(@rule_types, fn type ->
      type.is_rule_of_type?(rule)
    end)
  end

  def evaluate(rule, value) do
    case type(rule) do
      nil -> invalid_rule!(rule)
      type -> type.evaluate(rule, value)
    end
  end

  def result(rule, value) do
    %Result{
      rule: rule,
      evaluation: evaluate(rule, value),
      value: value
    }
  end

  defp invalid_rule!(rule) do
    raise ArgumentError, "Invalid rule: #{inspect(rule)}"
  end

  @doc """
  Returns the number of clauses this rule has.

  ## Examples

  iex> Spex.number_of_clauses([])
  0

  iex> rules = [fn _ -> true end]
  iex> Spex.number_of_clauses(rules)
  1

  iex> rules = [fn _ -> true end, Spex.Operator.any(fn _ -> false end, fn _ -> true end)]
  iex> Spex.number_of_clauses(rules)
  3
  """
  @spec number_of_clauses(t() | list(t)) :: non_neg_integer()
  # TODO: Move this into the rule types ...
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
