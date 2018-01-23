defmodule Specification.Rule do
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
  - `is_rule?/1` used to find the correct rule type
  - `evaluate/2` evaluates the given rule with the given value, returns the
  result of the evaluation
  - `result/2` returns a `Specification.Result` containing the evaluation result
  """
  alias Specification.{Result, Rule, Types}

  # A module implementing this behaviour
  @type t :: module()

  @callback is_rule?(any()) :: boolean()
  @callback evaluate(t(), Types.value()) :: Types.result_value()
  @callback result(t(), Types.value()) :: Types.result()

  defmacro __using__(_which) do
    quote do
      @before_compile unquote(__MODULE__)
      @behaviour unquote(__MODULE__)

      def result(rule, value) do
        %Specification.Result{
          rule: rule,
          result: evaluate(rule, value),
          value: value
        }
      end

      defoverridable result: 2
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def is_rule?(_other), do: false
    end
  end

  @rule_types rule_types

  def is_rule?(rule) do
    Enum.any?(@rule_types, &apply(&1, :is_rule?, [rule]))
  end

  def type(rule) do
    Enum.find(@rule_types, fn type ->
      type.is_rule?(rule)
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
      result: evaluate(rule, value),
      value: value
    }
  end

  defp invalid_rule!(rule) do
    raise ArgumentError, "Invalid rule: #{inspect(rule)}"
  end
end
