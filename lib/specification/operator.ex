defmodule Specification.Operator do
  @moduledoc """
  Operators to link rules with boolean logic.

  - `all` all given rules have to be valid (`and`)
  - `any` one given rule has to be valid (`or`)
  - `none` no given rule has to be valid (`not`)
  """

  @type t :: {rule(), clauses()}
  @type rule :: :all | :any | :none
  @type clause :: Specifiation.Types.rule()
  @type clauses :: list(clause())

  @rules [:all, :any, :none]

  @spec clauses(t(), rule() | nil) :: clauses()
  def clauses(operator, expected_rule \\ nil)

  @spec rule(t(), rule() | nil) :: rule()
  def rule(operator, expected_rule \\ nil)

  for rule <- @rules do
    @spec unquote(rule)() :: unquote(rule)
    def unquote(rule)(), do: unquote(rule)

    @spec unquote(rule)(clauses()) :: t()
    def unquote(rule)(clauses) do
      {unquote(rule), List.wrap(clauses)}
    end

    @spec unquote(rule)(clause(), clause()) :: t()
    def unquote(rule)(arg1, arg2) do
      unquote(rule)([arg1, arg2])
    end
  end

  for rule <- @rules do
    def clauses({unquote(rule), clauses}, nil), do: {:ok, clauses}
    def clauses({unquote(rule), clauses}, unquote(rule)), do: {:ok, clauses}
  end

  def clauses({actual, _clauses}, expected) when actual in @rules and expected in @rules do
    unexpected_operator(actual, expected)
  end

  def clauses(_operator, expected) when expected not in [nil | @rules] do
    invalid_expected(expected)
  end

  def clauses(other, _expected) do
    invalid_operator(other)
  end

  def clauses!(operator, expected_operator \\ nil) do
    case clauses(operator, expected_operator) do
      {:ok, clauses} ->
        clauses

      {:error, reason} ->
        raise ArgumentError,
              "Can't extract operator clauses from `#{inspect(operator)}`" <>
                ", received error: #{inspect(reason)}"
    end
  end

  for rule <- @rules do
    def rule({unquote(rule), _clauses}, nil), do: {:ok, unquote(rule)}
    def rule({unquote(rule), _clauses}, unquote(rule)), do: {:ok, unquote(rule)}
  end

  def rule({actual, _clauses}, expected) when actual in @rules and expected in @rules do
    unexpected_operator(actual, expected)
  end

  def rule(_operator, expected) when expected not in [nil | @rules] do
    invalid_expected(expected)
  end

  def rule(other, _expected) do
    invalid_operator(other)
  end

  def rule!(operator, expected_operator \\ nil) do
    case rule(operator, expected_operator) do
      {:ok, rule} ->
        rule

      {:error, reason} ->
        raise ArgumentError,
              "Can't extract operator rule from `#{inspect(operator)}`" <>
                ", received error: #{inspect(reason)}"
    end
  end

  @spec operator?(t()) :: boolean()
  def operator?(operator), do: match?({:ok, _rule}, rule(operator))
  def operator?(operator, rule), do: match?({:ok, ^rule}, rule(operator))

  defp unexpected_operator(actual, expected) do
    {:error, {:unexpected_operator, expected: expected, actual: actual}}
  end

  defp invalid_expected(expected_rule) do
    {:error, {:invalid_expected_rule, expected_rule}}
  end

  defp invalid_operator(invalid) do
    {:error, {:invalid_operator, invalid}}
  end
end
