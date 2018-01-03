defmodule Specification.Operator do
  @moduledoc """
  Operators to link rules with boolean logic.

  - `all` all given rules have to be valid (`and`)
  - `any` one given rule has to be valid (`or`)
  - `negate` no given rule has to be valid (`not`)
  """

  @type t :: {:all, value()} | {:any, value()} | {:negate, value()}
  @type value :: Specifiation.Types.rules()

  for rule <- [:all, :any, :negate] do
    def unquote(rule)(rules) do
      {unquote(rule), List.wrap(rules)}
    end

    def unquote(rule)(arg1, arg2) do
      unquote(rule)([arg1, arg2])
    end

    def clauses({unquote(rule), clauses}), do: {:ok, clauses}
    def rule({unquote(rule), _clauses}), do: {:ok, unquote(rule)}
  end

  def clauses(_other), do: {:error, :invalid_operator}
  def rule(_other), do: {:error, :invalid_operator}

  def clauses!(operator) do
    case clauses(operator) do
      {:ok, clauses} ->
        clauses

      {:error, :invalid_operator} ->
        raise ArgumentError, "Can't extract operator clauses from: #{operator}"
    end
  end

  def rule!(operator) do
    case rule(operator) do
      {:ok, rule} ->
        rule

      {:error, :invalid_operator} ->
        raise ArgumentError, "Can't extract operator rule from: #{operator}"
    end
  end

  def operator?(operator), do: match?({:ok, _rule}, rule(operator))
end
