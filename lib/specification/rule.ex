defmodule Specification.Rule do
  # One __could__ generate this: but that would require writing a recursive AST generating macro, so nope
  # @type t :: Rule.Function.t() | Rule.Module.t() | Rule.Operator.t() | Rule.Struct.t()
  @type t :: any()

  defprotocol Evaluable do
    @fallback_to_any false

    @spec evaluate(t(), Types.value()) :: Types.evaluation()
    def evaluate(rule, value)
  end

  defprotocol Resultable do
    @fallback_to_any true

    @spec result(t(), Types.value()) :: Types.result()
    def result(rule, value)
  end

  defprotocol Nestable do
    @fallback_to_any true

    @spec nested_rules(t()) :: list(t())
    def nested_rules(rule)
  end

  @spec evaluate(t(), Types.value()) :: Types.evaluation()
  defdelegate evaluate(rule, value), to: Evaluable

  @spec result(t(), Types.value()) :: Types.result()
  defdelegate result(rule, value), to: Resultable

  @spec nested_rules(t()) :: list(t())
  defdelegate nested_rules(rule), to: Nestable

  @doc """
  Returns the number of clauses this rule has.

  ## Examples

  iex> Specification.Rule.number_of_clauses([])
  0

  iex> rules = [fn _ -> true end]
  iex> Specification.Rule.number_of_clauses(rules)
  1

  iex> rules = [fn _ -> true end, Specification.Operator.any(fn _ -> false end, fn _ -> true end)]
  iex> Specification.Rule.number_of_clauses(rules)
  3
  """
  @spec number_of_clauses(t() | list(t())) :: non_neg_integer()
  def number_of_clauses(rule) do
    rule
    |> nested_rules()
    |> List.flatten()
    |> Enum.count()
  end
end
