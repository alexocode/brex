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

  defprotocol Nestable do
    @spec aggregator(t()) :: (list(boolean()) -> boolean())
    def aggregator(rule)

    @spec nested_rules(t()) :: list(t())
    def nested_rules(rule)
  end

  @doc """
  Calls `Evaluable.evaluate/2` with the given rule and value. This can raise a
  `Protocol.UndefinedError` if the given rule does not implement `Spex.Rule.Evaluable`.
  """
  @spec evaluate(t(), Types.value()) :: Types.evaluation()
  defdelegate evaluate(rule, value), to: Evaluable

  @doc """
  Calls `evaluate/2` with the given rule and value and wraps it into a
  `Spex.Result` struct.
  """
  @spec result(t(), Types.value()) :: Types.result()
  def result(rule, value) do
    %Spex.Result{
      evaluation: evaluate(rule, value),
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
  Returns `{:ok, list(t())}` if the rule implements Nestable and `:error` otherwise.

  ## Examples

      iex> Spex.Rule.nested_rules(Spex.Operator.all([&is_list/1, &is_map/1]))
      {:ok, [&is_list/1, &is_map/1]}

      iex> Spex.Rule.nested_rules(&is_list/1)
      :error

      iex> Spex.Rule.nested_rules("foo_bar")
      :error
  """
  @spec nested_rules(t()) :: {:ok, list(t())} | :error
  def nested_rules(rule) do
    case Nestable.impl_for(rule) do
      nil -> :error
      impl -> {:ok, impl.nested_rules(rule)}
    end
  end

  @doc """
  Returns the number of clauses this rule has.

  ## Examples

      iex> Spex.Rule.number_of_clauses([])
      0

      iex> rules = [fn _ -> true end]
      iex> Spex.Rule.number_of_clauses(rules)
      1

      iex> rules = [fn _ -> true end, Spex.Operator.any(fn _ -> false end, fn _ -> true end)]
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
    case nested_rules(rule) do
      {:ok, nested_rules} -> number_of_clauses(nested_rules)
      :error -> 1
    end
  end
end
